module Page.Drawings exposing
    ( Model
    , Msg
    , getAccount
    , getSession
    , handleRoute
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
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Db exposing (Db)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Id exposing (Id)
import Json.Decode as Decode
import Ports
import Route
import Route.Drawings exposing (Route)
import Session exposing (Session)
import Style
import Time exposing (Posix)
import Util.Cmd as CmdUtil
import Util.String as StringUtil
import View.Body as Body
import View.Button as Button
import View.Card as Card
import View.CardHeader as CardHeader
import View.Image as Image
import View.Input as Input
import View.InputGroup as InputGroup
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
    | CloseDrawingClicked
    | OpenDrawingInPaintAppClicked Drawing.PublicId
    | OpenDrawingLinkClicked Drawing.PublicId
    | CopyClicked Drawing.PublicId
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
    | LoadingAllDrawings Route
    | LoadingFailed (Listener.Error String)
    | Drawings
    | Deleting
    | DeleteFailed (Id Drawing) { error : String }
    | Deleted { drawingName : String }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Account -> Route -> ( Model, Cmd msg )
init session account route =
    ( { session = session
      , account = account
      , state = LoadingAllDrawings route
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


handleRoute : Route -> Model -> Model
handleRoute route model =
    case model.state of
        LoadingAllDrawings _ ->
            setState (LoadingAllDrawings route) model

        _ ->
            setState (routeToState route) model



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


routeToState : Route -> State
routeToState route =
    case route of
        Route.Drawings.Landing ->
            Drawings

        Route.Drawings.SpecificDrawing id ->
            SpecificDrawing id


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
    let
        session : Session
        session =
            getSession model
    in
    case model.state of
        SpecificDrawing id ->
            specificDrawingView
                (Db.getWithId model.drawings id)
                session
                |> SingleCardPage.view

        DeleteDrawing id ->
            deleteDrawingView
                (Db.getWithId model.drawings id)
                (Session.getContactEmail session)
                |> SingleCardPage.view

        LoadingAllDrawings _ ->
            Card.view
                []
                [ CardHeader.config
                    { title = "loading drawings" }
                    |> CardHeader.toHtml
                , Spinner.row
                ]
                |> SingleCardPage.view

        Drawings ->
            drawingsView (getDrawings model)

        Deleting ->
            Card.view
                []
                [ CardHeader.config
                    { title = "deleting" }
                    |> CardHeader.toHtml
                , Spinner.row
                ]
                |> SingleCardPage.view

        DeleteFailed id error ->
            failedToDeleteView
                (Db.getWithId model.drawings id)
                error
                |> SingleCardPage.view

        Deleted { drawingName } ->
            Card.view
                []
                [ CardHeader.config
                    { title = "deleted" }
                    |> CardHeader.toHtml
                , Card.textRow
                    []
                    ([ drawingName
                        |> StringUtil.quote
                     , "has been deleted"
                     ]
                        |> String.join " "
                    )
                ]
                |> SingleCardPage.view

        LoadingFailed error ->
            Card.errorView
                { title = "loading failed"
                , errorMessage =
                    """
                    Something went wrong. I was not able to load your drawings.
                    Below is the error. Sorry about that.
                    """
                , error =
                    Just
                        (Listener.errorToString identity error)
                }
                []
                |> SingleCardPage.view


failedToDeleteView : ( Id Drawing, Maybe Drawing ) -> { error : String } -> Html Msg
failedToDeleteView ( id, maybeDrawing ) { error } =
    Card.errorView
        { title = "error"
        , errorMessage =
            [ "Something didnt work. "
            , maybeDrawing
                |> Maybe.map
                    (Drawing.getName >> StringUtil.quote)
                |> Maybe.withDefault "Your drawing"
            , " might not have been deleted."
            ]
                |> String.concat
        , error = Just error
        }
        []


deleteDrawingView : ( Id Drawing, Maybe Drawing ) -> String -> Html Msg
deleteDrawingView ( id, maybeDrawing ) contactEmail =
    case maybeDrawing of
        Just drawing ->
            let
                quotedName : String
                quotedName =
                    StringUtil.quote
                        (Drawing.getName drawing)
            in
            Card.view
                []
                [ CardHeader.config
                    { title = "delete " ++ quotedName }
                    |> CardHeader.toHtml
                , Card.textRow
                    []
                    ([ "are you sure you want to delete "
                     , quotedName
                     , "?"
                     ]
                        |> String.concat
                    )
                , Button.row
                    [ Button.config
                        DeleteYesClicked
                        "yes"
                    , Button.config
                        DeleteNoClicked
                        "no"
                    ]
                ]

        Nothing ->
            drawingNotFound contactEmail


specificDrawingView : ( Id Drawing, Maybe Drawing ) -> Session -> Html Msg
specificDrawingView ( id, maybeDrawing ) session =
    case maybeDrawing of
        Just drawing ->
            let
                showTime : String -> (Drawing -> Posix) -> Html msg
                showTime label toTime =
                    [ label
                    , drawing
                        |> toTime
                        |> Session.formatTime session
                    ]
                        |> String.join " : "
                        |> Card.textRow [ Style.marginBottom 2 ]

                publicId : Drawing.PublicId
                publicId =
                    Drawing.getPublicId drawing
            in
            Card.view
                []
                [ CardHeader.config
                    { title = Drawing.getName drawing }
                    |> CardHeader.withCloseButton
                        { onClick = CloseDrawingClicked }
                    |> CardHeader.toHtml
                , Grid.row
                    [ Style.pit
                    , Style.marginBottom 2
                    ]
                    [ Grid.column
                        [ Style.maxWidth 9
                        , Style.maxHeight 9
                        ]
                        [ Image.config
                            (Image.drawing drawing)
                            |> Image.toHtml
                        ]
                    ]
                , showTime "created at" Drawing.getCreatedAt
                , showTime "updated at" Drawing.getUpdatedAt
                , InputGroup.config
                    { label = "image link"
                    , input =
                        [ Grid.row
                            []
                            [ Grid.column
                                []
                                [ publicId
                                    |> Drawing.getDrawingUrl
                                    |> Input.readOnly
                                    |> Input.toHtml
                                ]
                            , Grid.column
                                [ Grid.columnShrink
                                , Style.marginLeft 2
                                ]
                                [ Button.config
                                    (CopyClicked publicId)
                                    "copy url"
                                    |> Button.toHtml
                                ]
                            ]
                        ]
                    }
                    |> InputGroup.toHtml
                , Button.rowWithStyles
                    [ Style.fieldMarginTop ]
                    [ Button.config
                        (OpenDrawingLinkClicked publicId)
                        "open image link"
                        |> Button.asDoubleWidth
                    , Button.config
                        (OpenDrawingInPaintAppClicked publicId)
                        "open in ctpaint"
                        |> Button.asDoubleWidth
                    , Button.config
                        (DeleteDrawingClicked id)
                        "delete"
                    ]
                ]

        Nothing ->
            drawingNotFound
                (Session.getContactEmail session)


drawingNotFound : String -> Html Msg
drawingNotFound contactEmail =
    Card.view
        []
        [ CardHeader.config
            { title = "Could not find drawing" }
            |> CardHeader.toHtml
        , [ """
            This drawing doesnt exist. Maybe its been
            deleted? Maybe something went wrong. If
            this problem persists, please reach me at
            """
          , contactEmail
          ]
            |> String.join " "
            |> Card.textRow []
        ]


drawingsView : List ( Id Drawing, Drawing ) -> List (Html Msg)
drawingsView drawings =
    if List.isEmpty drawings then
        Card.view
            []
            [ Card.textRow [] "you have no drawings"
            , Button.row
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
        Body.view
            [ Style.padding 2
            , Css.flexDirection Css.column
            ]
            [ Grid.row
                [ Style.pit
                , Style.fullWidth
                , Style.padding 3
                , Css.flex (Css.int 1)
                ]
                (List.map drawingView drawings)
            ]


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
                        |> Image.onClick (DrawingClicked id)
                        |> Image.withStyles
                            [ Style.fullWidth ]
                        |> Image.toHtml
                    ]
                ]
            ]
        ]



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        navKey : NavKey
        navKey =
            Session.getNavKey <| getSession model
    in
    case msg of
        DrawingClicked id ->
            setState
                (SpecificDrawing id)
                model
                |> CmdUtil.withNoCmd

        CloseDrawingClicked ->
            ( model
            , goToDrawings navKey
            )

        OpenDrawingInPaintAppClicked id ->
            ( model
            , Route.goTo
                (Session.getNavKey model.session)
                (Route.paintAppFromDrawing id)
            )

        OpenDrawingLinkClicked id ->
            ( model
            , Ports.payload "open in new window"
                |> Ports.withString "url" (Drawing.getDrawingUrl id)
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
                    ( model
                    , Route.goToDrawings
                        navKey
                        (Route.Drawings.SpecificDrawing id)
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        MakeADrawingClicked ->
            ( model
            , goToNewDrawing navKey
            )

        RefreshClicked ->
            init
                (getSession model)
                (getAccount model)
                Route.Drawings.Landing

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

        CopyClicked publicId ->
            model
                |> CmdUtil.withNoCmd


goToNewDrawing : NavKey -> Cmd msg
goToNewDrawing navKey =
    Route.goTo
        navKey
        Route.InitDrawing


goToDrawings : NavKey -> Cmd msg
goToDrawings navKey =
    Route.goToDrawings
        navKey
        Route.Drawings.Landing


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        DrawingClicked _ ->
            Tracking.event "drawing clicked"

        CloseDrawingClicked ->
            Tracking.event "close drawing clicked"

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

        CopyClicked _ ->
            Tracking.event "copy clicked"



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
