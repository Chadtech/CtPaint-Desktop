module Util exposing (..)

import Html exposing (Attribute, Html)
import Html.Events exposing (keyCode, on)
import Json.Decode as Decode exposing (Decoder)
import Tuple.Infix exposing ((&))


-- CMD --


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd newCmd ( model, cmd ) =
    model & Cmd.batch [ newCmd, cmd ]


cmdIf : Bool -> Cmd msg -> Cmd msg
cmdIf condition cmd =
    if condition then
        cmd
    else
        Cmd.none


noCmd : a -> ( a, Cmd msg )
noCmd model =
    ( model, Cmd.none )



-- GENERAL --


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list


firstJust : List (Maybe a) -> Maybe a
firstJust maybes =
    case maybes of
        (Just v) :: rest ->
            Just v

        Nothing :: rest ->
            firstJust rest

        [] ->
            Nothing


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


viewMaybe : Maybe a -> (a -> Html msg) -> Html msg
viewMaybe maybe htmlFunc =
    case maybe of
        Just value ->
            htmlFunc value

        Nothing ->
            Html.text ""



-- EMAIL --


isValidEmail : String -> Bool
isValidEmail email =
    case String.split "@" email of
        "" :: _ ->
            False

        local :: domain :: [] ->
            separateDomain domain local

        _ ->
            False


separateDomain : String -> String -> Bool
separateDomain domain local =
    case String.split "." domain of
        _ :: "" :: [] ->
            False

        "" :: _ :: [] ->
            False

        name :: extension :: [] ->
            [ local, name, extension ]
                |> String.concat
                |> String.all isAlphanumeric

        _ ->
            False


isAlphanumeric : Char -> Bool
isAlphanumeric char =
    String.contains (String.fromChar char) alphanumeric


alphanumeric : String
alphanumeric =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
