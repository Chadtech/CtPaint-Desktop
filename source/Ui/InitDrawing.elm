module Ui.InitDrawing exposing
    ( Model
    , Msg
    , bodyView
    , init
    , track
    , update
    , view
    )

{-|

    InitDrawing is a component used to initialize
    the PaintApp. Its used in two places at the
    time of writing this: 0 in the init drawing page
    which only serves to initialize new drawings, and 1;
    in the home page one can start a new drawing, and
    this same menu is used.

-}

import Data.BackgroundColor as BackgroundColor exposing (BackgroundColor)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Route
import Route.PaintApp as PaintAppRoute
import Style
import Url
import Util.Cmd as CmdUtil
import Util.Maybe as MaybeUtil
import Util.String as StringUtil
import View.Button as Button
import View.ButtonRow as ButtonRow
import View.Card as Card
import View.CardHeader as CardHeader exposing (CardHeader)
import View.Input as Input
import View.InputGroup as InputGroup



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { name : String
    , width : Maybe Int
    , height : Maybe Int
    , url : String
    , backgroundColor : BackgroundColor
    }


type Msg
    = FromUrlClicked Bool
    | ColorClicked BackgroundColor
    | StartNewDrawingClicked
    | UrlUpdated String
    | WidthUpdated String
    | HeightUpdated String
    | NameUpdated String



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    { name = ""
    , width = Nothing
    , height = Nothing
    , url = ""
    , backgroundColor = BackgroundColor.black
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


initWidth : Int
initWidth =
    400


initHeight : Int
initHeight =
    400


getWidthUiStr : Model -> String
getWidthUiStr model =
    model.width
        |> Maybe.map String.fromInt
        |> Maybe.withDefault ""


getHeightUiStr : Model -> String
getHeightUiStr model =
    model.height
        |> Maybe.map String.fromInt
        |> Maybe.withDefault ""


setWidth : Int -> Model -> Model
setWidth newWidth model =
    { model | width = Just newWidth }


setHeight : Int -> Model -> Model
setHeight newHeight model =
    { model | height = Just newHeight }


toPaintAppParams : Model -> PaintAppRoute.Params
toPaintAppParams model =
    { dimensions =
        Just
            { width =
                [ model.width
                , model.height
                ]
                    |> MaybeUtil.firstValue
                    |> Maybe.withDefault initWidth
            , height =
                [ model.height
                , model.width
                ]
                    |> MaybeUtil.firstValue
                    |> Maybe.withDefault initHeight
            }
    , backgroundColor =
        Just model.backgroundColor
    , name =
        if StringUtil.isBlank model.name then
            Nothing

        else
            Just model.name
    }


fromUrlDisabled : Model -> Bool
fromUrlDisabled =
    .url >> StringUtil.isBlank



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Model -> ( Model, Cmd msg )
update navKey msg model =
    case msg of
        FromUrlClicked _ ->
            fromUrl navKey model

        NameUpdated str ->
            { model | name = str }
                |> CmdUtil.withNoCmd

        WidthUpdated "" ->
            setWidth 0 model
                |> CmdUtil.withNoCmd

        WidthUpdated str ->
            case String.toInt str of
                Just newWidth ->
                    setWidth newWidth model
                        |> CmdUtil.withNoCmd

                Nothing ->
                    model
                        |> CmdUtil.withNoCmd

        HeightUpdated "" ->
            setHeight 0 model
                |> CmdUtil.withNoCmd

        HeightUpdated str ->
            case String.toInt str of
                Just newHeight ->
                    setHeight newHeight model
                        |> CmdUtil.withNoCmd

                Nothing ->
                    model
                        |> CmdUtil.withNoCmd

        UrlUpdated str ->
            { model | url = str }
                |> CmdUtil.withNoCmd

        ColorClicked color ->
            { model | backgroundColor = color }
                |> CmdUtil.withNoCmd

        StartNewDrawingClicked ->
            ( model
            , model
                |> toPaintAppParams
                |> Route.paintAppWithParams
                |> Route.goTo navKey
            )


fromUrl : NavKey -> Model -> ( Model, Cmd msg )
fromUrl navKey model =
    if fromUrlDisabled model then
        model
            |> CmdUtil.withNoCmd

    else
        ( model
        , model.url
            |> Route.paintAppFromUrl
            |> Route.goTo navKey
        )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        FromUrlClicked disabled ->
            Tracking.event "from-url click"
                |> Tracking.withBool "disabled" disabled

        ColorClicked bgColor ->
            Tracking.event "color click"
                |> Tracking.withString
                    "color"
                    (BackgroundColor.toString bgColor)

        StartNewDrawingClicked ->
            Tracking.event "submit click"

        UrlUpdated _ ->
            Nothing

        WidthUpdated _ ->
            Nothing

        HeightUpdated _ ->
            Nothing

        NameUpdated _ ->
            Nothing



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


header : Model -> CardHeader msg
header model =
    CardHeader.config
        { title = "init drawing" }


view : List (Html msg) -> Html msg
view =
    Card.view [ Style.width 9 ]


bodyView : Model -> List (Html Msg)
bodyView model =
    [ newView model
    , [ Grid.row [ Style.verticalDivider ] [] ]
    , urlView model
    ]
        |> List.concat


newView : Model -> List (Html Msg)
newView model =
    let
        colorButton : BackgroundColor -> Html Msg
        colorButton backgroundColor =
            Button.noLabel
                (ColorClicked backgroundColor)
                |> Button.indent
                    (backgroundColor == model.backgroundColor)
                |> Button.toHtml
    in
    [ InputGroup.text
        { label = "name"
        , input =
            Input.config
                NameUpdated
                model.name
        }
        |> InputGroup.toHtml
    , InputGroup.text
        { label = "width"
        , input =
            Input.config
                WidthUpdated
                (getWidthUiStr model)
                |> Input.withPlaceholder
                    (String.fromInt initWidth ++ "px")
        }
        |> InputGroup.toHtml
    , InputGroup.text
        { label = "height"
        , input =
            Input.config
                HeightUpdated
                (getHeightUiStr model)
                |> Input.withPlaceholder
                    (String.fromInt initHeight ++ "px")
        }
        |> InputGroup.toHtml
    , InputGroup.config
        { label = "background color"
        , input =
            [ colorButton BackgroundColor.black
            , colorButton BackgroundColor.white
            ]
        }
        |> InputGroup.toHtml
    , ButtonRow.view
        [ Button.config
            StartNewDrawingClicked
            "start new drawing"
        ]
    ]


urlView : Model -> List (Html Msg)
urlView model =
    let
        buttonIsDisabled : Bool
        buttonIsDisabled =
            fromUrlDisabled model
    in
    [ InputGroup.text
        { label = "url"
        , input =
            Input.config
                UrlUpdated
                model.url
        }
        |> InputGroup.toHtml
    , ButtonRow.view
        [ Button.config
            (FromUrlClicked buttonIsDisabled)
            "start from url"
            |> Button.isDisabled buttonIsDisabled
        ]
    ]
