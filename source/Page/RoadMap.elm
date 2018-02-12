module Page.RoadMap
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
import Data.Taco exposing (Taco)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    ()


type Msg
    = WantClicked String



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WantClicked want ->
            model & Cmd.none



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace roadMapNamespace
        |> stylesheet


roadMapNamespace : String
roadMapNamespace =
    Html.Custom.makeNamespace "RoadMap"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace roadMapNamespace


view : Taco -> Model -> List (Html msg)
view taco model =
    []
