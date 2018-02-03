module Util exposing (..)

import Html exposing (Attribute, Html)
import Html.Events exposing (keyCode, on)
import Json.Decode as Decode exposing (Decoder)
import Tuple.Infix exposing ((&))


-- CMD --


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd newCmd ( model, cmd ) =
    model & Cmd.batch [ newCmd, cmd ]



-- GENERAL --


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list


contains : List a -> a -> Bool
contains =
    flip List.member



-- HTML --


showIf : Bool -> String -> String
showIf show str =
    if show then
        str
    else
        "********"


onEnter : msg -> Attribute msg
onEnter msg =
    on "keydown" (Decode.andThen (enterDecoder msg) keyCode)


enterDecoder : msg -> Int -> Decoder msg
enterDecoder msg code =
    if code == 13 then
        Decode.succeed msg
    else
        Decode.fail "Not enter"


viewIf : Bool -> Html msg -> Html msg
viewIf condition html =
    if condition then
        html
    else
        Html.text ""
