module Session exposing
    ( Session
    , decoder
    , getMountPath
    , getNavKey
    )

import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Session =
    { mountPath : MountPath
    , navKey : NavKey
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : NavKey -> Decoder Session
decoder navKey =
    Decode.succeed Session
        |> DecodeUtil.applyField "mountPath" MountPath.decoder
        |> DecodeUtil.apply (Decode.succeed navKey)


getMountPath : Session -> MountPath
getMountPath =
    .mountPath


getNavKey : Session -> NavKey
getNavKey =
    .navKey
