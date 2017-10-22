module Data.Session exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (required)


type alias Session =
    { username : String
    , email : String
    }


decode : Value -> Maybe Session
decode json =
    Decode.decodeValue decoder json
        |> Result.toMaybe


decoder : Decoder Session
decoder =
    Pipeline.decode Session
        |> required "nickname" Decode.string
        |> required "email" Decode.string
