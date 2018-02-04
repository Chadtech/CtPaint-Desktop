module Page.Offline
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
    = RefreshClicked



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        RefreshClicked ->
            Cmd.none



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace offlineNamespace
        |> stylesheet


offlineNamespace : String
offlineNamespace =
    Html.Custom.makeNamespace "Offline"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace offlineNamespace


view : List (Html Msg)
view =
    []
