module Page.Error exposing (..)

import Html exposing (Html, div, text)
import Msg exposing (Msg(..))


view : String -> Html Msg
view msg =
    div
        []
        [ text msg ]
