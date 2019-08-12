module Data.Config exposing
    ( Config
    , assetSrc
    , fromFlags
    )

import Data.Browser exposing (Browser)
import Data.Flags exposing (Flags)
import Data.SessionId as SessionId exposing (SessionId)
import Random as Random exposing (Seed)


{-|

    Formal term : Config
    A config is for values that dont change
    during run time, but cant be hardcoded

-}
type alias Config =
    { sessionId : SessionId
    , browser : Browser
    , mountPath : String
    , logoSrc : String
    , videoSrc : String
    , buildNumber : Int
    }


fromFlags : Flags -> ( Config, Seed )
fromFlags flags =
    flags.seed
        |> Random.step SessionId.generator
        |> Tuple.mapFirst (fromSessionId flags)


fromSessionId : Flags -> SessionId -> Config
fromSessionId flags sessionId =
    { sessionId = sessionId
    , browser = flags.browser
    , mountPath = flags.mountPath
    , logoSrc = "splash-image.png"
    , videoSrc = "splash-video.mp4"
    , buildNumber = flags.buildNumber
    }



-- HELPERS --


assetSrc : Config -> (Config -> String) -> String
assetSrc config assetFunc =
    config.mountPath ++ "/" ++ assetFunc config
