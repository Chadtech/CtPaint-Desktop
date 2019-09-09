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

import Css
import Data.Document exposing (Document)
import Data.Position exposing (Position)
import Data.Size as Size
import Data.Tool as Tool exposing (Tool)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Route exposing (Route)
import Session exposing (Session)
import Style
import Ui.Toolbar as Toolbar
import Util.Cmd as CmdUtil
import View.Body as Body



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , user : User
    , pendingNavigation : Maybe Route
    , viewMode : ViewMode
    , eraserSize : Int
    , tool : Tool
    , mousePosition : Position
    }


type ViewMode
    = Mode__Gallery
    | Mode__Normal


type Msg
    = ToolbarMsg Toolbar.Msg



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> Model
init session user =
    { session = session
    , user = user
    , pendingNavigation = Nothing
    , viewMode = Mode__Normal
    , eraserSize = 5
    , tool = Tool.init
    , mousePosition =
        Size.center <| Session.getWindowSize session
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
    { model | session = f model.session }


navigationIsOkay : Model -> Bool
navigationIsOkay model =
    False



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


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
                ]
                []
            ]
        , colorBar
        ]


taskbar : Html msg
taskbar =
    Grid.row
        [ Style.height 5 ]
        []


colorBar : Html msg
colorBar =
    Grid.row
        [ Style.height 6 ]
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
