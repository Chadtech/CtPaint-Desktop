module Page.Settings
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
import Data.User exposing (User)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    ()


type Msg
    = Noop



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> User -> Model -> ( Model, Cmd Msg )
update msg user model =
    case msg of
        Noop ->
            model & Cmd.none



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace settingsNamespace
        |> stylesheet


settingsNamespace : String
settingsNamespace =
    Html.Custom.makeNamespace "Settings"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace settingsNamespace


view : Model -> List (Html Msg)
view model =
    []
