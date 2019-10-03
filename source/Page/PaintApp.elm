module Page.PaintApp exposing
    ( Model
    , Msg
    , getSession
    , getUser
    , init
    , listeners
    , mapSession
    , navigationIsOkay
    , track
    , update
    , view
    )

import Color exposing (Color)
import Css
import Data.BackgroundColor as BackgroundColor exposing (BackgroundColor)
import Data.Document exposing (Document)
import Data.Listener as Listener exposing (Listener)
import Data.OrderedSet exposing (OrderedSet)
import Data.Palette as Palette exposing (Palette)
import Data.Position exposing (Position)
import Data.Size as Size exposing (Size)
import Data.Swatches as Swatches exposing (Swatches)
import Data.Tool as Tool exposing (Tool)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Lazy as HtmlLazy
import Json.Decode as Decode
import Json.Encode as Encode
import Ports
import Route exposing (Route)
import Route.PaintApp as PaintAppRoute
import Session exposing (Session)
import Style
import Ui.Toolbar as Toolbar
import Util.Cmd as CmdUtil
import Util.List as ListUtil
import Util.Random as RandomUtil
import View.Body as Body
import View.Button as Button
import View.ColorBox as ColorBox



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , user : User
    , pendingNavigation : Maybe Route
    , mousePosition : Position
    , viewMode : ViewMode

    -- TOOLS
    --
    , eraserSize : Int
    , tool : Tool

    -- COLORS
    --
    , swatches : Swatches
    , palette : Palette

    -- LAYERS
    , canvasManagerConnection : CanvasManagerConnection
    }


type alias InitCanvasParams =
    { dimensions : Size
    , backgroundColor : BackgroundColor
    , name : String
    }


type CanvasManagerConnection
    = CanvasManager__Connecting PaintAppRoute.Route
    | CanvasManager__Connected
    | CanvasManager__Failed (Listener.Error String)


type ViewMode
    = Mode__Gallery
    | Mode__Normal


type Msg
    = ToolbarMsg Toolbar.Msg
    | PaletteColorClicked Int
    | AddPaletteColorClicked
    | CanvasManagerInitialized (Listener.Response String ())



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> PaintAppRoute.Route -> Model
init session user paintAppRoute =
    { session = session
    , user = user
    , pendingNavigation = Nothing
    , viewMode = Mode__Normal
    , eraserSize = 5
    , tool = Tool.init
    , mousePosition =
        Size.center <| Session.getWindowSize session
    , swatches = Swatches.default
    , palette = Palette.default
    , canvasManagerConnection =
        CanvasManager__Connecting paintAppRoute
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    setSession (f <| getSession model) model


navigationIsOkay : Model -> Bool
navigationIsOkay model =
    False



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setSession : Session -> Model -> Model
setSession session model =
    { model | session = session }


encodeInitCanvasParams : InitCanvasParams -> Encode.Value
encodeInitCanvasParams { dimensions, backgroundColor } =
    [ Tuple.pair "width" <|
        Encode.int dimensions.width
    , Tuple.pair "height" <|
        Encode.int dimensions.height
    , Tuple.pair "backgroundColor" <|
        BackgroundColor.encode backgroundColor
    ]
        |> Encode.object


resolveRouteParams : Session -> PaintAppRoute.Params -> ( InitCanvasParams, Session )
resolveRouteParams session params =
    let
        ( name, newSession ) =
            case params.name of
                Just givenName ->
                    ( givenName, session )

                Nothing ->
                    Session.stepRandom
                        (RandomUtil.alphanumeric 16)
                        session
    in
    ( { dimensions =
            params.dimensions
                |> Maybe.withDefault (Size.square 400)
      , backgroundColor =
            params.backgroundColor
                |> Maybe.withDefault BackgroundColor.white
      , name = name
      }
    , newSession
    )


setCanvasManagerError : Listener.Error String -> Model -> Model
setCanvasManagerError error model =
    { model
        | canvasManagerConnection =
            CanvasManager__Failed error
    }


mapSwatches : (Swatches -> Swatches) -> Model -> Model
mapSwatches f model =
    { model | swatches = f model.swatches }


mapPalette : (Palette -> Palette) -> Model -> Model
mapPalette f model =
    { model | palette = f model.palette }


setTool : Tool -> Model -> Model
setTool tool model =
    { model | tool = tool }


incrementEraserSize : Model -> Model
incrementEraserSize model =
    setEraserSize (model.eraserSize + 1) model


decrementEraserSize : Model -> Model
decrementEraserSize model =
    setEraserSize (model.eraserSize - 1) model


setEraserSize : Int -> Model -> Model
setEraserSize newEraserSize model =
    { model
        | eraserSize =
            newEraserSize
                |> min maxEraserSize
                |> max minEraserSize
    }


maxEraserSize : Int
maxEraserSize =
    8


minEraserSize : Int
minEraserSize =
    2



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    { title = Nothing
    , body =
        case model.viewMode of
            Mode__Gallery ->
                -- TODO Gallery View
                []

            Mode__Normal ->
                normalView model
    }


normalView : Model -> List (Html Msg)
normalView model =
    let
        clickScreen : Html Msg
        clickScreen =
            Html.div
                [ Attrs.css
                    [ Css.position Css.absolute
                    , Css.left Css.zero
                    , Css.top Css.zero
                    , Css.right Css.zero
                    , Css.bottom Css.zero
                    ]
                ]
                []
    in
    Body.view
        [ Css.displayFlex
        , Css.flexDirection Css.column
        ]
        [ taskbar
        , Grid.row
            [ Css.flex (Css.int 1) ]
            [ Toolbar.view
                { eraserSize = model.eraserSize
                , toolOption =
                    Toolbar.optionFromTool model.tool
                }
                |> Grid.mapColumn ToolbarMsg
            , Grid.column
                [ Style.pit
                , Style.buttonMarginRight
                , Style.relative
                ]
                [ clickScreen
                , HtmlLazy.lazy canvasManagerView
                    (Session.getCanvasManagerNodeName <|
                        getSession model
                    )
                ]
            ]
        , HtmlLazy.lazy2
            colorBar
            model.swatches
            model.palette
        ]


canvasManagerView : String -> Html Msg
canvasManagerView nodeName =
    Html.node nodeName [] []


taskbar : Html msg
taskbar =
    Grid.row
        [ Style.height 5 ]
        []


colorBar : Swatches -> Palette -> Html Msg
colorBar swatches palette =
    Grid.row
        [ Style.height 6
        , Style.padding 2
        ]
        [ swatchesView swatches
        , Grid.column
            [ Style.pit
            , Style.marginLeft 2
            , Style.scroll
            ]
            [ HtmlLazy.lazy
                paletteView
                palette
            ]
        , infoView
        ]


swatchesView : Swatches -> Grid.Column Msg
swatchesView swatches =
    let
        spacing : Int
        spacing =
            2
    in
    -- TODO make lazy
    Grid.column
        [ Css.flexDirection Css.column
        , Grid.exactWidthColumn (Style.sizePx 7)
        ]
        [ Grid.row
            [ Style.grow
            , Style.paddingBottom spacing
            ]
            [ Grid.column
                []
                [ ColorBox.fromColor
                    swatches.top
                    |> ColorBox.toHtml
                ]
            ]
        , Grid.row
            [ Style.grow ]
            [ Grid.column
                [ Style.paddingRight spacing ]
                [ ColorBox.fromColor
                    swatches.left
                    |> ColorBox.toHtml
                ]
            , Grid.column
                [ Css.flex (Css.int 2) ]
                [ ColorBox.fromColor
                    swatches.bottom
                    |> ColorBox.toHtml
                ]
            , Grid.column
                [ Style.paddingLeft spacing ]
                [ ColorBox.fromColor
                    swatches.right
                    |> ColorBox.toHtml
                ]
            ]
        ]


paletteView : Palette -> Html Msg
paletteView palette =
    let
        squareSize : Size
        squareSize =
            { width = 5, height = 5 }

        squareView : Int -> Color -> Grid.Column Msg
        squareView index paletteColor =
            Grid.column
                [ Css.flex (Css.int 0) ]
                [ paletteColor
                    |> ColorBox.fromColor
                    |> ColorBox.setSize squareSize
                    |> ColorBox.onClick
                        (PaletteColorClicked index)
                    |> ColorBox.toHtml
                ]

        addSquareButton : Grid.Column Msg
        addSquareButton =
            Grid.column
                []
                [ Button.config
                    AddPaletteColorClicked
                    "+"
                    |> Button.withSize squareSize
                    |> Button.toHtml
                ]

        squares : List (Grid.Column Msg)
        squares =
            palette
                |> Palette.toList
                |> List.indexedMap squareView
                |> ListUtil.push addSquareButton
    in
    Grid.row
        [ Css.flexWrap Css.wrap ]
        squares


infoView : Grid.Column msg
infoView =
    Grid.column
        [ Style.pit
        , Style.marginLeft 2
        , Grid.exactWidthColumn (Style.sizePx 9)
        ]
        []



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToolbarMsg subMsg ->
            updateFromToolbar subMsg model
                |> CmdUtil.withNoCmd

        PaletteColorClicked index ->
            case Palette.get index model.palette of
                Just color ->
                    mapSwatches
                        (Swatches.setTop color)
                        model
                        |> CmdUtil.withNoCmd

                Nothing ->
                    -- TODO record unexpected case
                    model
                        |> CmdUtil.withNoCmd

        AddPaletteColorClicked ->
            mapPalette
                Palette.addColor
                model
                |> CmdUtil.withNoCmd

        CanvasManagerInitialized response ->
            case response of
                Ok () ->
                    case model.canvasManagerConnection of
                        CanvasManager__Connecting subRoute ->
                            handleCanvasManagerInitialization subRoute model

                        _ ->
                            -- TODO record unexpected case
                            model
                                |> CmdUtil.withNoCmd

                Err error ->
                    setCanvasManagerError error model
                        |> CmdUtil.withNoCmd


handleCanvasManagerInitialization : PaintAppRoute.Route -> Model -> ( Model, Cmd Msg )
handleCanvasManagerInitialization route model =
    let
        session : Session
        session =
            getSession model

        initializeCanvases : List ( String, Encode.Value ) -> Ports.Payload
        initializeCanvases canvases =
            Ports.payload "initialize layers"
                |> Ports.withProp
                    "canvases"
                    (canvases |> Encode.object)

        initializeFromParams : PaintAppRoute.Params -> ( Model, Cmd Msg )
        initializeFromParams routeParams =
            let
                ( resolvedParams, newSession ) =
                    resolveRouteParams
                        session
                        routeParams
            in
            ( setSession newSession model
            , initializeCanvases
                [ Tuple.pair "layer-0" <|
                    encodeInitCanvasParams resolvedParams
                ]
                |> Ports.sendToCanvasManager
            )
    in
    case route of
        PaintAppRoute.Landing ->
            initializeFromParams
                { dimensions = Nothing
                , name = Nothing
                , backgroundColor = Nothing
                }

        PaintAppRoute.WithParams params ->
            initializeFromParams params

        PaintAppRoute.FromUrl _ ->
            -- TODO from url
            model
                |> CmdUtil.withNoCmd

        PaintAppRoute.FromDrawing id ->
            model
                |> CmdUtil.withNoCmd


updateFromToolbar : Toolbar.Msg -> Model -> Model
updateFromToolbar msg model =
    case msg of
        Toolbar.OptionClicked (Toolbar.ToolOption option) ->
            setTool
                (Toolbar.initToolFromOption option)
                model

        Toolbar.OptionClicked (Toolbar.MenuOption option) ->
            -- TODO open the menus!
            model

        Toolbar.OptionClicked (Toolbar.ActionOption option) ->
            -- TODO Do the action!
            model

        Toolbar.IncreaseEraserClicked ->
            incrementEraserSize model

        Toolbar.DecreaseEraserClicked ->
            decrementEraserSize model


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        ToolbarMsg subMsg ->
            Toolbar.track subMsg

        PaletteColorClicked _ ->
            Tracking.event "palette color clicked"

        AddPaletteColorClicked ->
            Tracking.event "add palette color clicked"

        CanvasManagerInitialized response ->
            Tracking.event "canvas manager initialized"
                |> Tracking.withListenerResponse response



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listeners : List (Listener Msg)
listeners =
    [ Listener.for
        { name = "canvas manager init"
        , decoder =
            [ Decode.map Ok (Decode.null ())
            , Decode.map Err Decode.string
            ]
                |> Decode.oneOf
        , handler = CanvasManagerInitialized
        }
    ]
