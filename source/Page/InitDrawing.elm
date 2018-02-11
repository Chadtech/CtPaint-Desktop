module Page.InitDrawing
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div, form, input, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onSubmit)
import Ports exposing (JsMsg(OpenPaintApp, OpenUrlInPaintApp))
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    { urlField : String }


type Msg
    = UrlFieldUpdated String
    | NewClicked
    | FromUrlClicked
    | Submitted



-- INIT --


init : Model
init =
    { urlField = "" }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlFieldUpdated str ->
            { model | urlField = str } & Cmd.none

        NewClicked ->
            openPaintApp model

        FromUrlClicked ->
            fromUrl model

        Submitted ->
            case model.urlField of
                "" ->
                    openPaintApp model

                _ ->
                    fromUrl model


openPaintApp : Model -> ( Model, Cmd Msg )
openPaintApp model =
    model & Ports.send OpenPaintApp


fromUrl : Model -> ( Model, Cmd Msg )
fromUrl model =
    model & Ports.send (OpenUrlInPaintApp model.urlField)



-- STYLES --


type Class
    = Text
    | Background


css : Stylesheet
css =
    [ Css.class Background
        [ backgroundColor backgroundx2
        , position absolute
        , top zero
        , left zero
        , bottom zero
        , right zero
        ]
    ]
        |> namespace initDrawingNamespace
        |> stylesheet


initDrawingNamespace : String
initDrawingNamespace =
    Html.Custom.makeNamespace "InitDrawing"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace initDrawingNamespace


view : Model -> Html Msg
view model =
    [ Html.Custom.header
        { text = "open ctpaint"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ form
            [ onSubmit Submitted ]
            [ Html.Custom.field []
                [ p
                    [ class [ Text ] ]
                    [ Html.text "New" ]
                , input
                    [ class [] ]
                    []
                ]
            ]
        ]
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> div [ class [ Background ] ]
