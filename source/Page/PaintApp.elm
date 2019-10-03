module Page.PaintApp exposing
    ( Model
    , Msg
    , getSession
    , getUser
    , init
    , mapSession
    , navigationIsOkay
    , track
    , update
    , view
    )

import Color exposing (Color)
import Css
import Data.Document exposing (Document)
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
import Ports
import Route exposing (Route)
import Session exposing (Session)
import Style
import Ui.Toolbar as Toolbar
import Util.Cmd as CmdUtil
import Util.List as ListUtil
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
    }


type ViewMode
    = Mode__Gallery
    | Mode__Normal


type Msg
    = ToolbarMsg Toolbar.Msg
    | PaletteColorClicked Int
    | AddPaletteColorClicked



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> ( Model, Cmd msg )
init session user =
    ( { session = session
      , user = user
      , pendingNavigation = Nothing
      , viewMode = Mode__Normal
      , eraserSize = 5
      , tool = Tool.init
      , mousePosition =
            Size.center <| Session.getWindowSize session
      , swatches = Swatches.default
      , palette = Palette.default
      }
    , Ports.payload "init canvas manager"
        |> Ports.send
    )



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
    { model | session = f model.session }


navigationIsOkay : Model -> Bool
navigationIsOkay model =
    False



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


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
                , HtmlLazy.lazy canvasContainer
                    (Session.getCanvasContainerId <|
                        getSession model
                    )
                ]
            ]
        , HtmlLazy.lazy2
            colorBar
            model.swatches
            model.palette
        ]


canvasContainer : String -> Html Msg
canvasContainer canvasContainerId =
    Html.div
        [ Attrs.css
            []
        , Attrs.id canvasContainerId
        ]
        []


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
