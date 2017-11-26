module Page.Error exposing (css, view)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div, p, text)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Route exposing (Route(..))


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
    "Error"



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
                [ onClick (Navigate Home) ]
                [ Html.text "go home" ]
            ]
        ]
