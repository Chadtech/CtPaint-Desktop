module Html.InitDrawing
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html, a, div, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports
    exposing
        ( JsMsg
            ( OpenPaintApp
            , OpenPaintAppWithParams
            , OpenUrlInPaintApp
            )
        )
import Tuple.Infix exposing ((&), (:=), (|&))


-- TYPES --


type alias Model =
    { name : String
    , width : Int
    , widthField : String
    , height : Int
    , heightField : String
    , url : String
    , backgroundColor : BackgroundColor
    }


toQueryString : Model -> String
toQueryString { name, width, height, backgroundColor } =
    [ "width=" ++ toString (max 1 width)
    , "height=" ++ toString (max 1 height)
    , "background_color=" ++ colorToString backgroundColor
    ]
        |> String.join "&"
        |> addNameQueryString name
        |> (++) "?"


addNameQueryString : String -> String -> String
addNameQueryString name queryStr =
    case name of
        "" ->
            queryStr

        _ ->
            queryStr ++ "&name=" ++ name


type Msg
    = FromUrlClicked
    | UrlInitSubmitted
    | ColorClicked BackgroundColor
    | NewInitSubmitted
    | StartNewDrawingClicked
    | FieldUpdated Field String


type Field
    = Url
    | Width
    | Height
    | Name


type BackgroundColor
    = Black
    | White


colorToString : BackgroundColor -> String
colorToString color =
    case color of
        Black ->
            "black"

        White ->
            "white"



-- INIT --


init : Model
init =
    { name = ""
    , width = 400
    , widthField = ""
    , height = 400
    , heightField = ""
    , url = ""
    , backgroundColor = Black
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FromUrlClicked ->
            fromUrl model

        UrlInitSubmitted ->
            case model.url of
                "" ->
                    openPaintApp model

                _ ->
                    fromUrl model

        FieldUpdated Name str ->
            { model | name = str } & Cmd.none

        FieldUpdated Width str ->
            { model | widthField = str }
                |> validateWidth
                & Cmd.none

        FieldUpdated Height str ->
            { model | heightField = str }
                |> validateHeight
                & Cmd.none

        FieldUpdated Url str ->
            { model | url = str } & Cmd.none

        ColorClicked color ->
            { model | backgroundColor = color } & Cmd.none

        NewInitSubmitted ->
            openPaintApp model

        StartNewDrawingClicked ->
            openPaintApp model


validateWidth : Model -> Model
validateWidth model =
    case String.toInt model.widthField of
        Ok int ->
            { model | width = int }

        Err _ ->
            model


validateHeight : Model -> Model
validateHeight model =
    case String.toInt model.heightField of
        Ok int ->
            { model | height = int }

        Err _ ->
            model


openPaintApp : Model -> ( Model, Cmd Msg )
openPaintApp model =
    model
        |> toQueryString
        |> OpenPaintAppWithParams
        |> Ports.send
        |& model


fromUrl : Model -> ( Model, Cmd Msg )
fromUrl model =
    model & Ports.send (OpenUrlInPaintApp model.url)



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
    [ newView model
    , div [ class [ Divider ] ] []
    , urlView model
    ]
        |> Html.Custom.cardBody []


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
        (startNewButtonAttrs model)
        [ Html.text "start new drawing" ]
    ]
        |> form [ onSubmit NewInitSubmitted ]


startNewButtonAttrs : Model -> List (Attribute Msg)
startNewButtonAttrs model =
    [ class [ Button ]
    , onClick StartNewDrawingClicked
    ]


colorBox : BackgroundColor -> BackgroundColor -> Html Msg
colorBox thisColor selectedColor =
    div
        [ classList
            [ ColorBox := True
            , colorToStyle thisColor := True
            , Selected := (selectedColor == thisColor)
            , Left := thisColor == Black
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
            [ Button := True
            , Disabled := model.url == ""
            ]
        ]
        [ Html.text "start from url" ]
    ]
        |> form
            [ onSubmit UrlInitSubmitted ]
