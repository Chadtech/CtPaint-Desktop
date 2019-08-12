module Data.MountPath exposing
    ( MountPath
    , decoder
    , path
    )

import Json.Decode as Decode exposing (Decoder)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type MountPath
    = MountPath String



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


decoder : Decoder MountPath
decoder =
    Decode.map MountPath Decode.string


path : MountPath -> List String -> String
path (MountPath mountpath) extra =
    String.join "/" (mountpath :: extra)
