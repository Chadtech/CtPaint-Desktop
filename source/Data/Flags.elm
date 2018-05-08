module Data.Flags exposing (Flags, decoder)

import Data.User as User
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, decode, optional, required)
import Keyboard.Extra.Browser
    exposing
        ( Browser
            ( Chrome
            , FireFox
            )
        )
import Random.Pcg as Random exposing (Seed)


{-|

    Formal term : Flags
    These are the initial values of the Elm app
    that come from the JavaScript side of the whole
    application. The flags are decoded from JSON

-}
type alias Flags =
    { user : User.Model
    , isMac : Bool
    , browser : Browser
    , buildNumber : Int
    , mountPath : String
    , seed : Seed
    }



-- DECODER --


decoder : Decoder Flags
decoder =
    decode Flags
        |> custom userDecoder
        |> optional "isMac" Decode.bool True
        |> required "browser" browserDecoder
        |> required "buildNumber" Decode.int
        |> required "mountPath" Decode.string
        |> required "seed" (Decode.map Random.initialSeed Decode.int)


userDecoder : Decoder User.Model
userDecoder =
    browserDecoder
        |> Decode.field "browser"
        |> Decode.andThen
            (User.decoder >> Decode.field "user")


browserDecoder : Decoder Browser
browserDecoder =
    Decode.string
        |> Decode.andThen toBrowser


toBrowser : String -> Decoder Browser
toBrowser browser =
    case browser of
        "Firefox" ->
            Decode.succeed FireFox

        "Chrome" ->
            Decode.succeed Chrome

        "Unknown" ->
            Decode.succeed Chrome

        other ->
            Decode.fail ("Unknown browser type " ++ other)
