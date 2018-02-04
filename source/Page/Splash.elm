module Page.Splash
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom


-- TYPES --


type Msg
    = Noop



-- UPDATE --


update : Msg -> Cmd Msg
update Noop =
    Cmd.none



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace splashNamespace
        |> stylesheet


splashNamespace : String
splashNamespace =
    Html.Custom.makeNamespace "Splash"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace splashNamespace


view : List (Html Msg)
view =
    []
