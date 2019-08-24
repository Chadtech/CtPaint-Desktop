module Page.Home exposing
    ( Model
    , Msg
    , getSession
    , init
    , track
    , update
    , view
    )

import Css
import Data.Account exposing (Account)
import Data.Document exposing (Document)
import Data.Drawing as Drawing exposing (Drawing)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Id exposing (Id)
import Ports
import Route
import Session exposing (Session)
import Style
import Ui.InitDrawing as InitDrawing
import Util.Cmd as CmdUtil
import View.Body as Body
import View.Image as Image
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session Account
    , state : State
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


type State
    = SpecificDrawing (Id Drawing)
    | DeleteDrawing (Id Drawing)
    | LoadingAllDrawings
    | LoadingDrawing
    | Drawings
    | Deleting
    | DeleteFailed (Id Drawing) String
    | Deleted String
    | NewDrawing InitDrawing.Model



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session Account -> ( Model, Cmd msg )
init session =
    ( { session = session
      , state = LoadingAllDrawings
      }
    , getDrawings
    )



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session Account
getSession =
    .session



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


getDrawings : Cmd msg
getDrawings =
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
    , body =
        Body.view
            [ Grid.column
                [ Grid.exactWidthColumn (Style.sizePx 8)
                , Style.padding 1
                , Css.flexDirection Css.column
                ]
                (leftSide <| Session.getUser model.session)
            , Grid.column
                [ Style.padding 1 ]
                [ Grid.box
                    [ Style.pit
                    , Style.fullWidth
                    ]
                    []
                ]
            ]
    }


leftSide : Account -> List (Html msg)
leftSide account =
    let
        profilePicView : String -> Html msg
        profilePicView url =
            Image.config
                (Image.thirdParty url)
                |> Image.toHtml

        noProfilePic : Html msg
        noProfilePic =
            Text.fromString "no profile pic"
    in
    [ Grid.row
        [ Style.pit
        , Style.fullWidth
        , Css.paddingTop (Css.pct 100)
        , Style.noOverflow
        , Style.relative
        ]
        [ Grid.column
            [ Css.position Css.absolute
            , Css.left Css.zero
            , Css.top Css.zero
            ]
            [ account.profilePic
                |> Maybe.map profilePicView
                |> Maybe.withDefault noProfilePic
            ]
        ]
    ]



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
            , getDrawings
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
