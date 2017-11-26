module Data.User exposing (Model(..), User, decoder)

import Data.Keys as Keys
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)


type Model
    = NoSession
    | Offline
    | LoggingIn
    | LoggingOut
    | LoggedIn User


type alias User =
    { email : String
    , name : String
    , profilePic : String
    , keyConfig : Keys.Config
    }



-- DECODER --


decoder : Decoder Model
decoder =
    [ Decode.null NoSession
    , Decode.string |> Decode.andThen offlineDecoder
    , userDecoder |> Decode.map LoggedIn
    ]
        |> Decode.oneOf


offlineDecoder : String -> Decoder Model
offlineDecoder str =
    if str == "offline" then
        Decode.succeed Offline
    else
        Decode.fail "not offline"


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "email" Decode.string
        |> required "nickname" Decode.string
        |> required "picture" Decode.string
        |> required "key-config" Keys.configDecoder
