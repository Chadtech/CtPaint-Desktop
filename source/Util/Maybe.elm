module Util.Maybe exposing (fromBool)


fromBool : Bool -> a -> Maybe a
fromBool bool value =
    if bool then
        Just value

    else
        Nothing


cons : Maybe a -> List a -> List a
cons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list


firstValue : List (Maybe a) -> Maybe a
firstValue maybes =
    case maybes of
        (Just v) :: _ ->
            Just v

        Nothing :: rest ->
            firstValue rest

        [] ->
            Nothing
