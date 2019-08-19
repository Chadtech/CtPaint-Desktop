module Util.Json.Decode exposing
    ( apply
    , applyField
    , errorToSanitizedString
    , fallback
    , matchString
    , matchStringMany
    , set
    )

import Json.Decode as Decode exposing (Decoder)


apply : Decoder a -> Decoder (a -> b) -> Decoder b
apply =
    let
        applyHelp : a -> (a -> b) -> b
        applyHelp v f =
            f v
    in
    Decode.map2 applyHelp


applyField : String -> Decoder a -> Decoder (a -> b) -> Decoder b
applyField fieldName decoder =
    apply (Decode.field fieldName decoder)


set : a -> Decoder (a -> b) -> Decoder b
set value =
    apply (Decode.succeed value)


fallback : a -> Decoder a -> Decoder a
fallback value decoder =
    [ decoder
    , Decode.succeed value
    ]
        |> Decode.oneOf


errorToSanitizedString : Decode.Error -> String
errorToSanitizedString error =
    case error of
        Decode.Field string fieldError ->
            [ "error at field"
            , string
            , "->"
            , errorToSanitizedString fieldError
            ]
                |> String.join " "

        Decode.Index index indexError ->
            [ "error at index"
            , String.fromInt index
            , "->"
            , errorToSanitizedString indexError
            ]
                |> String.join " "

        Decode.OneOf errors ->
            [ "error in these attempts ->"
            , List.map errorToSanitizedString errors
                |> String.join ", "
            ]
                |> String.join " "

        Decode.Failure string _ ->
            string


matchStringMany : List ( String, a ) -> Decoder a
matchStringMany =
    let
        matchThis : ( String, a ) -> Decoder a
        matchThis ( str, value ) =
            matchString str value
    in
    List.map matchThis >> Decode.oneOf


matchString : String -> a -> Decoder a
matchString str value =
    let
        fromString : String -> Decoder a
        fromString decodedStr =
            if decodedStr == str then
                Decode.succeed value

            else
                Decode.fail ("String is not " ++ str)
    in
    Decode.string
        |> Decode.andThen fromString
