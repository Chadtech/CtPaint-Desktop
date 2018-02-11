module Page.About
    exposing
        ( css
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div, p)
import Html.CssHelpers
import Html.Custom


-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace aboutNamespace
        |> stylesheet


aboutNamespace : String
aboutNamespace =
    Html.Custom.makeNamespace "About"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace aboutNamespace


view : List (Html msg)
view =
    []
