module Page.Error
    exposing
        ( Msg
        , css
        , track
        , update
        , view
        )

import Css exposing (..)
import Data.Tracking as Tracking
import Html exposing (Html, p)
import Html.Events exposing (onClick)


-- TYPES --


type Msg
    = GoHomeClicked



-- UPDATE --


update : Msg -> Cmd msg
update GoHomeClicked =
    Route.goTo Route.Landing



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track GoHomeClicked =
    Tracking.noProps "go-home click"



-- STYLES --


type Class
    = Card


css : Stylesheet
css =
    [ Css.class Card
        [ maxWidth (pct 75)
        , overflow hidden
        ]
    ]
        |> namespace errorNamespace
        |> stylesheet


errorNamespace : String
errorNamespace =
    Html.Custom.makeNamespace "Error"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace errorNamespace


view : String -> Html Msg
view msg =
    Html.Custom.cardSolitary
        [ class [ Card ] ]
        [ Html.Custom.header
            { text = "error"
            , closability = Html.Custom.NotClosable
            }
        , Html.Custom.cardBody []
            [ p [] [ Html.text msg ]
            , Html.Custom.menuButton
                [ onClick GoHomeClicked ]
                [ Html.text "go home" ]
            ]
        ]
