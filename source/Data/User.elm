module Data.User exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (required)


type alias User =
    { username : String
    , email : String
    }


decode : Value -> Maybe User
decode json =
    Decode.decodeValue decoder json
        |> Result.toMaybe


decoder : Decoder User
decoder =
    Pipeline.decode User
        |> required "nickname" Decode.string
        |> required "email" Decode.string


isLoggedIn : Value -> Bool
isLoggedIn json =
    Decode.decodeValue
        (Decode.field "isLoggedIn" Decode.bool)
        json
        |> Result.withDefault False
