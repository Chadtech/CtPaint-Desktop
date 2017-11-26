module Page.Error exposing (..)

import Html exposing (Html, a, div, p, text)
import Html.Custom
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Route exposing (Route(..))


view : String -> Html Msg
view msg =
    Html.Custom.card []
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
