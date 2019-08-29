module Session exposing
    ( Session
    , decoder
    , getBuildNumber
    , getMountPath
    , getNavKey
    , getSessionId
    , setWindowSize
    )

import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Data.SessionId as SessionId exposing (SessionId)
import Data.Size exposing (Size)
import Json.Decode as Decode exposing (Decoder)
import Random exposing (Seed)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Session =
    { mountPath : MountPath
    , navKey : NavKey
    , buildNumber : BuildNumber
    , sessionId : SessionId
    , seed : Seed
    , windowSize : Size
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


setWindowSize : Size -> Session -> Session
setWindowSize newSize session =
    { session | windowSize = newSize }


decoder : NavKey -> Decoder Session
decoder navKey =
    let
        windowSizeDecoder : Decoder Size
        windowSizeDecoder =
            Decode.succeed Size
                |> DecodeUtil.applyField "windowHeight" Decode.int
                |> DecodeUtil.applyField "windowWidth" Decode.int

        fromSeed : Seed -> Decoder Session
        fromSeed seed0 =
            let
                ( sessionId, seed1 ) =
                    Random.step
                        SessionId.generator
                        seed0
            in
            Decode.succeed Session
                |> DecodeUtil.applyField "mountPath" MountPath.decoder
                |> DecodeUtil.set navKey
                |> DecodeUtil.applyField "buildNumber" BuildNumber.decoder
                |> DecodeUtil.set sessionId
                |> DecodeUtil.set seed1
                |> DecodeUtil.apply windowSizeDecoder
    in
    Decode.map Random.initialSeed Decode.int
        |> Decode.field "seed"
        |> Decode.andThen fromSeed


getBuildNumber : Session -> BuildNumber
getBuildNumber =
    .buildNumber


getMountPath : Session -> MountPath
getMountPath =
    .mountPath


getNavKey : Session -> NavKey
getNavKey =
    .navKey


getSessionId : Session -> SessionId
getSessionId =
    .sessionId
