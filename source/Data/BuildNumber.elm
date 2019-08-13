module Data.BuildNumber exposing
    ( BuildNumber
    , decoder
    , toString
    )

import Json.Decode as Decode exposing (Decoder)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type BuildNumber
    = BuildNumber Int



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


toString : BuildNumber -> String
toString (BuildNumber int) =
    String.fromInt int


decoder : Decoder BuildNumber
decoder =
    Decode.map BuildNumber Decode.int
