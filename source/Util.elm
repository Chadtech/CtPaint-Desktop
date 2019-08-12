module Util exposing
    ( firstJust
    , maybeCons
    , replace
    , showIf
    , viewMaybe
    )

import Html exposing (Html)



-- STRING --


replace : String -> String -> String -> String
replace target replacement str =
    str
        |> String.split target
        |> String.join replacement



-- MAYBE --


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



-- HTML --


showIf : Bool -> String -> String
showIf show str =
    if show then
        str

    else
        "********"


viewMaybe : Maybe a -> (a -> Html msg) -> Html msg
viewMaybe maybe htmlFunc =
    case maybe of
        Just value ->
            htmlFunc value

        Nothing ->
            Html.text ""
