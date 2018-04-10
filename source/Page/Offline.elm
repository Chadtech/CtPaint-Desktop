module Page.Offline
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Ports
import Tracking exposing (Event(PageOfflineRefreshClick))


-- TYPES --


type Msg
    = RefreshClicked



-- UPDATE --


update : Taco -> Msg -> Cmd Msg
update taco msg =
    case msg of
        RefreshClicked ->
            PageOfflineRefreshClick
                |> Ports.track taco



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
