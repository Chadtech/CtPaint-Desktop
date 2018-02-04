module Page.Error
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div, p, text)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Route


-- TYPES --


type Msg
    = GoHomeClicked



-- UPDATE --


update : Msg -> Cmd msg
update GoHomeClicked =
    Route.goTo Route.Home



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
    Html.Custom.cardSolitary [ class [ Card ] ]
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
