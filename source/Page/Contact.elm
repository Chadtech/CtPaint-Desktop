module Page.Contact
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
        |> namespace contactNamespace
        |> stylesheet


contactNamespace : String
contactNamespace =
    Html.Custom.makeNamespace "Contact"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace contactNamespace


view : List (Html msg)
view =
    []
