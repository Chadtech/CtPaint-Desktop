module Page.Error exposing (..)

import Html exposing (Html, a, div, p, text)
import Html.Events exposing (onClick)
import Msg exposing (Msg(..))
import Route exposing (Route(..))
import Styles exposing (Classes(..), helpers)


{ class } =
    helpers


view : String -> Html Msg
view msg =
    div
        [ class [ Card, Solitary ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "Error" ] ]
        , div
            [ class [ Body ] ]
            [ p
                [ class [ HasBottomMargin ] ]
                [ text msg ]
            , a
                [ class [ Submit ]
                , onClick (Navigate Home)
                ]
                [ text "go home" ]
            ]
        ]
