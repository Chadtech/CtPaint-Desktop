module Data.Flags exposing (Flags, decoder)

import Data.Account as User
import Data.Browser as Browser exposing (Browser)
import Json.Decode as Decode exposing (Decoder)
import Random exposing (Seed)
import Util.Json.Decode as DecodeUtil


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
    Decode.succeed Flags
        |> DecodeUtil.apply userDecoder
        |> DecodeUtil.applyField "isMac" (DecodeUtil.fallback True Decode.bool)
        |> DecodeUtil.applyField "browser" Browser.decoder
        |> DecodeUtil.applyField "buildNumber" Decode.int
        |> DecodeUtil.applyField "mountPath" Decode.string
        |> DecodeUtil.applyField "seed" (Decode.map Random.initialSeed Decode.int)


userDecoder : Decoder User.Model
userDecoder =
    Browser.decoder
        |> Decode.field "browser"
        |> Decode.andThen
            (User.decoder >> Decode.field "user")
