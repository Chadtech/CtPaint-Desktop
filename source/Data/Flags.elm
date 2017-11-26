module Data.Flags exposing (Flags, decoder)

import Data.User as User
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, decode, optional, required)


type alias Flags =
    { user : User.Model }



-- DECODER --


decoder : Decoder Flags
decoder =
    decode Flags
        |> required "user" User.decoder
