module Data.Account exposing
    ( Account
    , None
    , decoder
    , getName
    , none
    )

import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Account =
    { email : String
    , name : String
    }


{-| As in "no user"
-}
type None
    = None



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


none : None
none =
    None


decoder : Decoder Account
decoder =
    Decode.succeed Account
        |> DecodeUtil.apply (Decode.field "email" Decode.string)
        |> DecodeUtil.apply (Decode.field "name" Decode.string)


getName : Account -> String
getName =
    .name
