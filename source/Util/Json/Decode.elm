module Util.Json.Decode exposing
    ( apply
    , applyField
    , fallback
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


fallback : a -> Decoder a -> Decoder a
fallback value decoder =
    [ decoder
    , Decode.succeed value
    ]
        |> Decode.oneOf
