module Page.Offline exposing
    ( Msg
    , css
    , track
    , update
    , view
    )

import Data.Tracking as Tracking
import Html exposing (Html)
import Ports exposing (JsMsg)



-- TYPES --


type Msg
    = RefreshClicked



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        RefreshClicked ->
            Ports.send RefreshPage



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        RefreshClicked ->
            Tracking.noProps "refresh click"



-- STYLES --


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
