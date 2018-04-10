module Page.Error
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, div, p, text)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Ports
import Route
import Tracking exposing (Event(PageErrorGoHomeClick))


-- TYPES --


type Msg
    = GoHomeClicked



-- UPDATE --


update : Taco -> Msg -> Cmd msg
update taco GoHomeClicked =
    [ Route.goTo Route.Landing
    , Ports.track taco PageErrorGoHomeClick
    ]
        |> Cmd.batch



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
