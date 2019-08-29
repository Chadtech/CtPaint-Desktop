module Page.Home exposing
    ( Model
    , Msg
    , getAccount
    , getSession
    , init
    , listeners
    , mapSession
    , track
    , update
    , view
    )

import Css
import Data.Account exposing (Account)
import Data.Document exposing (Document)
import Data.Drawing as Drawing exposing (Drawing)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Db exposing (Db)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Id exposing (Id)
import Json.Decode as Decode
import Ports
import Route
import Session exposing (Session)
import Style
import Ui.InitDrawing as InitDrawing
import Util.Cmd as CmdUtil
import View.Body as Body
import View.Button as Button
import View.ButtonRow as ButtonRow
import View.Card as Card
import View.CardHeader as CardHeader
import View.Image as Image
import View.SingleCardPage as SingleCardPage
import View.Spinner as Spinner



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , account : Account
    , state : State
    , drawings : Db Drawing
    }


type Msg
    = DrawingClicked (Id Drawing)
    | NewDrawingClicked
    | CloseDrawingClicked
    | CloseNewDrawingClicked
    | InitDrawingMsg InitDrawing.Msg
    | OpenDrawingInPaintAppClicked (Id Drawing)
    | OpenDrawingLinkClicked Drawing.PublicId
    | DeleteDrawingClicked (Id Drawing)
    | DeleteYesClicked
    | DeleteNoClicked
    | MakeADrawingClicked
    | RefreshClicked
    | BackToDrawingsClicked
    | TryAgainClicked
    | GotAllDrawings (Listener.Response String (Db Drawing))


type State
    = SpecificDrawing (Id Drawing)
    | DeleteDrawing (Id Drawing)
    | LoadingAllDrawings
    | LoadingDrawing
    | LoadingFailed (Listener.Error String)
    | Drawings
    | Deleting
    | DeleteFailed (Id Drawing) String
    | Deleted String
    | NewDrawing InitDrawing.Model



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Account -> ( Model, Cmd msg )
init session account =
    ( { session = session
      , account = account
      , state = LoadingAllDrawings
      , drawings = Db.empty
      }
    , allDrawingsRequest
    )



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getAccount : Model -> Account
getAccount =
    .account


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


getDrawings : Model -> List ( Id Drawing, Drawing )
getDrawings =
    .drawings >> Db.toList


loadingFailed : Listener.Error String -> Model -> Model
loadingFailed error model =
    { model | state = LoadingFailed error }


receiveDrawings : Db Drawing -> Model -> Model
receiveDrawings drawings model =
    { model
        | state = Drawings
        , drawings = drawings
    }


allDrawingsRequest : Cmd msg
allDrawingsRequest =
    Ports.payload "get drawings"
        |> Ports.send


deleteDrawing : Id Drawing -> Cmd msg
deleteDrawing id =
    Ports.payload "delete drawing"
        |> Ports.withId "drawingId" id
        |> Ports.send


setState : State -> Model -> Model
setState newState model =
    { model | state = newState }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    { title = Nothing
    , body = viewBody model
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.state of
        SpecificDrawing id ->
            []

        DeleteDrawing id ->
            []

        LoadingAllDrawings ->
            Card.view
                []
                [ CardHeader.config
                    { title = "loading drawings" }
                    |> CardHeader.toHtml
                , Spinner.row
                ]
                |> SingleCardPage.view

        LoadingDrawing ->
            []

        Drawings ->
            drawingsView (getDrawings model)

        Deleting ->
            []

        DeleteFailed id string ->
            []

        Deleted string ->
            []

        NewDrawing initDrawingModel ->
            []

        LoadingFailed string ->
            []


drawingsView : List ( Id Drawing, Drawing ) -> List (Html Msg)
drawingsView drawings =
    if List.isEmpty drawings then
        Card.view
            []
            [ Card.textRow [] "you have no drawings"
            , ButtonRow.view
                [ Button.config
                    RefreshClicked
                    "reload drawings"
                , Button.config
                    MakeADrawingClicked
                    "make a drawing"
                ]
            ]
            |> SingleCardPage.view

    else
        let
            drawingView : ( Id Drawing, Drawing ) -> Grid.Column Msg
            drawingView ( id, drawing ) =
                Grid.column
                    []
                    [ Card.view
                        [ Style.width 8
                        , Style.height 8
                        , Css.displayFlex
                        , Css.flexDirection Css.column
                        ]
                        [ CardHeader.config
                            { title = drawing.name }
                            |> CardHeader.toHtml
                        , Grid.row
                            [ Style.fullWidth
                            , Style.pit
                            , Css.flex (Css.int 1)
                            , Style.noOverflow
                            ]
                            [ Grid.column
                                [ Style.fullWidth
                                , Css.displayFlex
                                , Style.centerContent
                                , Css.flexDirection Css.column
                                ]
                                [ Image.config
                                    (Image.drawing drawing)
                                    |> Image.withStyles
                                        [ Style.fullWidth ]
                                    |> Image.toHtml
                                ]
                            ]
                        ]
                    ]
        in
        [ Grid.column
            [ Style.padding 2
            , Css.flexDirection Css.column
            ]
            [ Grid.row
                [ Style.paddingBottom 2 ]
                [ Grid.column
                    []
                    [ ButtonRow.view
                        [ Button.config
                            NewDrawingClicked
                            "new drawing"
                            |> Button.asDoubleWidth
                        ]
                    ]
                ]
            , Grid.row
                [ Style.pit
                , Style.fullWidth
                , Style.padding 3
                , Css.flex (Css.int 1)
                ]
                (List.map drawingView drawings)
            ]
        ]
            |> Body.view



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DrawingClicked id ->
            setState
                (SpecificDrawing id)
                model
                |> CmdUtil.withNoCmd

        NewDrawingClicked ->
            initNewDrawing model

        CloseDrawingClicked ->
            goToDrawings model

        CloseNewDrawingClicked ->
            goToDrawings model

        InitDrawingMsg subMsg ->
            case model.state of
                NewDrawing subModel ->
                    let
                        ( newSubModel, cmd ) =
                            InitDrawing.update
                                (Session.getNavKey model.session)
                                subMsg
                                subModel
                    in
                    ( setState
                        (NewDrawing newSubModel)
                        model
                    , cmd
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        OpenDrawingInPaintAppClicked id ->
            ( setState LoadingDrawing model
            , Route.goTo
                (Session.getNavKey model.session)
                (Route.paintAppFromDrawing id)
            )

        OpenDrawingLinkClicked id ->
            ( model
            , Ports.payload "open in new window"
                |> Ports.withString "url" (Drawing.toUrl id)
                |> Ports.send
            )

        DeleteDrawingClicked id ->
            setState (DeleteDrawing id) model
                |> CmdUtil.withNoCmd

        DeleteYesClicked ->
            case model.state of
                DeleteDrawing id ->
                    ( setState Deleting model
                      -- TODO make sure this works
                    , deleteDrawing id
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        DeleteNoClicked ->
            case model.state of
                DeleteDrawing id ->
                    setState
                        (SpecificDrawing id)
                        model
                        |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        MakeADrawingClicked ->
            initNewDrawing model

        RefreshClicked ->
            ( setState LoadingAllDrawings model
            , allDrawingsRequest
            )

        BackToDrawingsClicked ->
            setState Drawings model
                |> CmdUtil.withNoCmd

        TryAgainClicked ->
            case model.state of
                DeleteFailed id _ ->
                    ( setState Deleting model
                    , deleteDrawing id
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        GotAllDrawings response ->
            case response of
                Ok drawings ->
                    receiveDrawings drawings model
                        |> CmdUtil.withNoCmd

                Err err ->
                    loadingFailed err model
                        |> CmdUtil.withNoCmd


initNewDrawing : Model -> ( Model, Cmd msg )
initNewDrawing =
    setState (NewDrawing InitDrawing.init)
        >> CmdUtil.withNoCmd


goToDrawings : Model -> ( Model, Cmd msg )
goToDrawings =
    setState Drawings
        >> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        DrawingClicked _ ->
            Tracking.event "drawing clicked"

        NewDrawingClicked ->
            Tracking.event "new drawing clicked"

        CloseDrawingClicked ->
            Tracking.event "close drawing clicked"

        CloseNewDrawingClicked ->
            Tracking.event "close new drawing clicked"

        InitDrawingMsg subMsg ->
            InitDrawing.track subMsg

        OpenDrawingInPaintAppClicked _ ->
            Tracking.event "open drawing in paint app clicked"

        OpenDrawingLinkClicked _ ->
            Tracking.event "open drawing link clicked"

        DeleteDrawingClicked _ ->
            Tracking.event "delete drawing clicked"

        DeleteYesClicked ->
            Tracking.event "delete yes clicked"

        DeleteNoClicked ->
            Tracking.event "delete no clicked"

        MakeADrawingClicked ->
            Tracking.event "make a drawing clicked"

        RefreshClicked ->
            Tracking.event "refresh clicked"

        BackToDrawingsClicked ->
            Tracking.event "back to drawings clicked"

        TryAgainClicked ->
            Tracking.event "try again clicked"

        GotAllDrawings response ->
            Tracking.event "got all drawings"
                |> Tracking.withListenerResponse response



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listeners : List (Listener Msg)
listeners =
    [ Listener.for
        { name = "drawings"
        , decoder =
            [ Decode.list Drawing.decoder
                |> Decode.map Db.fromList
                |> Decode.map Ok
            , Decode.field "name" Decode.string
                |> Decode.map Err
            ]
                |> Decode.oneOf
        , handler = GotAllDrawings
        }
    ]
