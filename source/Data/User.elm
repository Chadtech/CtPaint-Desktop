module Data.User exposing (Model(..), User, decoder, userDecoder)

import Data.Keys as Keys
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline
    exposing
        ( custom
        , decode
        , required
        )
import Keyboard.Extra.Browser exposing (Browser)


type Model
    = Offline
    | LoggedOut
    | LoggingIn
    | LoggedIn User
    | LoggingOut


type alias User =
    { email : String
    , name : String
    , profilePic : String
    , keyConfig : Keys.Config
    }



-- DECODER --


decoder : Browser -> Decoder Model
decoder browser =
    [ Decode.null LoggedOut
    , Decode.string |> Decode.andThen offlineDecoder
    , userDecoder browser |> Decode.map LoggedIn
    ]
        |> Decode.oneOf


offlineDecoder : String -> Decoder Model
offlineDecoder str =
    if str == "offline" then
        Decode.succeed Offline
    else
        Decode.fail "not offline"


userDecoder : Browser -> Decoder User
userDecoder browser =
    decode User
        |> required "email" Decode.string
        |> required "name" Decode.string
        |> required "picture" Decode.string
        |> custom (configDecoder browser)


configDecoder : Browser -> Decoder Keys.Config
configDecoder browser =
    decode (,,,)
        |> required "custom:keyconfig0" keyConfigPartDecoder
        |> required "custom:keyconfig1" keyConfigPartDecoder
        |> required "custom:keyconfig2" keyConfigPartDecoder
        |> required "custom:keyconfig3" keyConfigPartDecoder
        |> Decode.andThen (fromPartsToKeyConfig browser)


fromPartsToKeyConfig :
    Browser
    -> ( String, String, String, String )
    -> Decoder Keys.Config
fromPartsToKeyConfig browser ( p0, p1, p2, p3 ) =
    [ p0, p1, p2, p3 ]
        |> String.concat
        |> Decode.decodeString
            (Keys.configDecoder browser)
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
