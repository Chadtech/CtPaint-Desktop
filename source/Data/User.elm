module Data.User exposing (Model(..), User, decoder, userDecoder)

import Data.Keys as Keys
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (custom, decode, required)


type Model
    = NoSession
    | Offline
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
        |> required "name" Decode.string
        |> required "picture" Decode.string
        |> custom configDecoder


configDecoder : Decoder Keys.Config
configDecoder =
    decode (,,,)
        |> required "custom:keyconfig0" keyConfigPartDecoder
        |> required "custom:keyconfig1" keyConfigPartDecoder
        |> required "custom:keyconfig2" keyConfigPartDecoder
        |> required "custom:keyconfig3" keyConfigPartDecoder
        |> Decode.andThen fromPartsToKeyConfig


fromPartsToKeyConfig : ( String, String, String, String ) -> Decoder Keys.Config
fromPartsToKeyConfig ( p0, p1, p2, p3 ) =
    [ p0, p1, p2, p3 ]
        |> String.concat
        |> Decode.decodeString Keys.configDecoder
        |> resultToDecoder


resultToDecoder : Result String Keys.Config -> Decoder Keys.Config
resultToDecoder result =
    case result of
        Ok config ->
            Decode.succeed config

        Err err ->
            Decode.fail err


keyConfigPartDecoder : Decoder String
keyConfigPartDecoder =
    Decode.map ifNotEnded Decode.string


ifNotEnded : String -> String
ifNotEnded str =
    case str of
        "CONFIG ENDED" ->
            ""

        other ->
            other
