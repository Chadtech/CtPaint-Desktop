module Ui.InitDrawing exposing
    ( Model
    , Msg
    , css
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
import Data.Tracking as Tracking
import Json.Encode as Encode
import Util.Cmd as CmdUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { name : String
    , width : Int
    , height : Int
    , url : String
    , backgroundColor : BackgroundColor
    , submitted : Bool
    }


type Msg
    = FromUrlClicked
    | ColorClicked BackgroundColor
    | NewInitSubmitted
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
    , width = 400
    , height = 400
    , url = ""
    , backgroundColor = BackgroundColor.black
    , submitted = False
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setWidth : Int -> Model -> Model
setWidth newWidth model =
    { model | width = newWidth }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FromUrlClicked ->
            fromUrl model

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

        NewInitSubmitted ->
            openPaintApp model

        StartNewDrawingClicked ->
            openPaintApp model





openPaintApp : Model -> ( Model, Cmd Msg )
openPaintApp model =
    (model
        |> toQueryString
    ,


fromUrl : Model -> ( Model, Cmd Msg )
fromUrl model =
    if String.isEmpty model.url then
        model
            |> R2.withNoCmd

    else
        OpenUrlInPaintApp model.url
            |> Ports.send
            |> R2.withModel
                { model | submitted = True }



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        FromUrlClicked ->
            model
                |> fromUrlDisabled
                |> Encode.bool
                |> def "disabled"
                |> List.singleton
                |> def "from-url click"
                |> Just

        UrlInitSubmitted ->
            Tracking.noProps "from-url enter press"

        FieldUpdated _ _ ->
            Nothing

        ColorClicked bgColor ->
            bgColor
                |> toString
                |> Encode.string
                |> def "color"
                |> List.singleton
                |> def "color click"
                |> Just

        NewInitSubmitted ->
            Tracking.noProps "submit enter press"

        StartNewDrawingClicked ->
            Tracking.noProps "submit click"


fromUrlDisabled : Model -> Bool
fromUrlDisabled =
    .url >> String.isEmpty



-- STYLES --


type Class
    = Label
    | UrlField
    | Divider
    | Button
    | NewSection
    | Selected
    | WhiteClass
    | BlackClass
    | ColorBox
    | ColorsContainer
    | Disabled
    | Left
    | InitializingText


css : Stylesheet
css =
    [ Css.class Label
        [ marginRight (px 8)
        , width (px 200)
        ]
    , Css.class NewSection
        []
    , Css.class Button
        [ margin2 zero auto
        , display table
        , withClass Disabled
            [ backgroundColor Ct.ignorable1
            , active Html.Custom.outdent
            , hover
                [ color Ct.point0 ]
            ]
        ]
    , (Css.class Divider << List.append Html.Custom.indent)
        [ margin auto
        , display block
        , marginTop (px 8)
        , marginBottom (px 8)
        ]
    , (Css.class ColorBox << List.append Html.Custom.outdent)
        [ height (px 19)
        , paddingTop (px 1)
        , width (px 107)
        , marginRight (px 8)
        , display inlineBlock
        , cursor pointer
        , withClass BlackClass
            [ backgroundColor (hex "#000000") ]
        , withClass WhiteClass
            [ backgroundColor (hex "#ffffff") ]
        , withClass Selected
            Html.Custom.indent
        , active Html.Custom.indent
        ]
    , Css.class Left
        [ marginRight (px 8) ]
    , Css.class InitializingText
        [ marginBottom (px 8) ]
    , Css.class ColorsContainer
        [ display inlineBlock ]
    ]
        |> namespace initDrawingNamespace
        |> stylesheet


colorToStyle : BackgroundColor -> Class
colorToStyle backgroundColor =
    case backgroundColor of
        White ->
            WhiteClass

        Black ->
            BlackClass


initDrawingNamespace : String
initDrawingNamespace =
    Html.Custom.makeNamespace "InitDrawing"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace initDrawingNamespace


view : Model -> Html Msg
view model =
    Html.Custom.cardBody [] (bodyView model)


bodyView : Model -> List (Html Msg)
bodyView model =
    if model.submitted then
        loadingView

    else
        [ newView model
        , div [ class [ Divider ] ] []
        , urlView model
        ]


loadingView : List (Html Msg)
loadingView =
    [ p
        [ class [ InitializingText ] ]
        [ Html.text "initializing" ]
    , Html.Custom.spinner
    ]


newView : Model -> Html Msg
newView model =
    [ Html.Custom.field []
        [ label "name"
        , input
            [ Attrs.value model.name
            , Attrs.spellcheck False
            , onInput (FieldUpdated Name)
            ]
            []
        ]
    , Html.Custom.field []
        [ label "width"
        , input
            [ Attrs.value model.widthField
            , Attrs.placeholder
                (toString model.width ++ "px")
            , Attrs.spellcheck False
            , onInput (FieldUpdated Width)
            ]
            []
        ]
    , Html.Custom.field []
        [ label "height"
        , input
            [ Attrs.value model.heightField
            , Attrs.placeholder
                (toString model.height ++ "px")
            , Attrs.spellcheck False
            , onInput (FieldUpdated Height)
            ]
            []
        ]
    , Html.Custom.field []
        [ label "background color"
        , div
            [ class [ ColorsContainer ] ]
            [ colorBox Black model.backgroundColor
            , colorBox White model.backgroundColor
            ]
        ]
    , a
        [ class [ Button ]
        , onClick StartNewDrawingClicked
        ]
        [ Html.text "start new drawing" ]
    ]
        |> form [ onSubmit NewInitSubmitted ]


colorBox : BackgroundColor -> BackgroundColor -> Html Msg
colorBox thisColor selectedColor =
    div
        [ classList
            [ def ColorBox True
            , def (colorToStyle thisColor) True
            , def Selected (selectedColor == thisColor)
            , def Left (thisColor == Black)
            ]
        , onClick (ColorClicked thisColor)
        ]
        []


label : String -> Html Msg
label str =
    p
        [ class [ Label ] ]
        [ Html.text str ]


urlView : Model -> Html Msg
urlView model =
    [ Html.Custom.field
        [ class [ UrlField ] ]
        [ p
            [ class [ Label ] ]
            [ Html.text "url" ]
        , input
            [ class [ UrlField ]
            , Attrs.value model.url
            , onInput (FieldUpdated Url)
            ]
            []
        ]
    , a
        [ classList
            [ def Button True
            , def Disabled (fromUrlDisabled model)
            ]
        , onClick FromUrlClicked
        ]
        [ Html.text "start from url" ]
    ]
        |> form
            [ onSubmit UrlInitSubmitted ]
