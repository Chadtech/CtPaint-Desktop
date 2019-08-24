module Session exposing
    ( Session
    , decoder
    , getBuildNumber
    , getMountPath
    , getNavKey
    , getSessionId
    , getUser
    , mapViewer
    , removeAccount
    , setUser
    , userLoggedIn
    )

import Data.Account as Account exposing (Account)
import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Data.SessionId as SessionId exposing (SessionId)
import Data.User as Viewer exposing (User)
import Json.Decode as Decode exposing (Decoder)
import Random exposing (Seed)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Session user =
    { mountPath : MountPath
    , navKey : NavKey
    , buildNumber : BuildNumber
    , user : user
    , sessionId : SessionId
    , seed : Seed
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


removeAccount : Session user -> Session Account.None
removeAccount =
    setUser Account.none


setUser : newUser -> Session user -> Session newUser
setUser =
    mapViewer << always


decoder : NavKey -> Decoder (Session User)
decoder navKey =
    let
        fromSeed : Seed -> Decoder (Session User)
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
    , user = f session.user
    , sessionId = getSessionId session
    , seed = session.seed
    }


userLoggedIn : Account -> Session User -> Session User
userLoggedIn account session =
    { session | user = Viewer.Account account }


getBuildNumber : Session user -> BuildNumber
getBuildNumber =
    .buildNumber


getMountPath : Session user -> MountPath
getMountPath =
    .mountPath


getNavKey : Session user -> NavKey
getNavKey =
    .navKey


getSessionId : Session user -> SessionId
getSessionId =
    .sessionId


getUser : Session user -> user
getUser =
    .user
