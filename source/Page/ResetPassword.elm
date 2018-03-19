module Page.ResetPassword
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Ports exposing (JsMsg(ResetPassword))
import Route
import Tuple.Infix exposing ((&))


-- TYPES --


type Model
    = Working
    | Success
    | Fail


type Msg
    = GoHomeClicked


init : String -> String -> ( Model, Cmd Msg )
init email code =
    ( Working
    , Ports.send (ResetPassword email code)
    )



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoHomeClicked ->
            model & Route.goTo Route.Landing



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace resetNamespace
        |> stylesheet


resetNamespace : String
resetNamespace =
    Html.Custom.makeNamespace "ResetPassword"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace resetNamespace


view : Model -> Html Msg
view model =
    Html.text "yeah"
