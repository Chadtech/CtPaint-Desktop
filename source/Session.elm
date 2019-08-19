module Session exposing
    ( Session
    , decoder
    , getBuildNumber
    , getMountPath
    , getNavKey
    , getSessionId
    , getViewer
    , mapViewer
    , setViewer
    , userLoggedIn
    )

import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Data.SessionId as SessionId exposing (SessionId)
import Data.User exposing (User)
import Data.Viewer as Viewer exposing (Viewer)
import Json.Decode as Decode exposing (Decoder)
import Random exposing (Seed)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Session viewer =
    { mountPath : MountPath
    , navKey : NavKey
    , buildNumber : BuildNumber
    , viewer : viewer
    , sessionId : SessionId
    , seed : Seed
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : NavKey -> Decoder (Session Viewer)
decoder navKey =
    let
        fromSeed : Seed -> Decoder (Session Viewer)
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
                |> DecodeUtil.applyField "viewer" Viewer.decoder
                |> DecodeUtil.set sessionId
                |> DecodeUtil.set seed1
    in
    Decode.map Random.initialSeed Decode.int
        |> Decode.field "seed"
        |> Decode.andThen fromSeed


mapViewer : (v -> u) -> Session v -> Session u
mapViewer f session =
    { mountPath = getMountPath session
    , navKey = getNavKey session
    , buildNumber = getBuildNumber session
    , viewer = f session.viewer
    , sessionId = getSessionId session
    , seed = session.seed
    }


setViewer : newViewer -> Session viewer -> Session newViewer
setViewer newViewer =
    mapViewer (always newViewer)


userLoggedIn : User -> Session Viewer -> Session Viewer
userLoggedIn user session =
    { session | viewer = Viewer.User user }


getBuildNumber : Session viewer -> BuildNumber
getBuildNumber =
    .buildNumber


getMountPath : Session viewer -> MountPath
getMountPath =
    .mountPath


getNavKey : Session viewer -> NavKey
getNavKey =
    .navKey


getSessionId : Session viwer -> SessionId
getSessionId =
    .sessionId


getViewer : Session viewer -> viewer
getViewer =
    .viewer
