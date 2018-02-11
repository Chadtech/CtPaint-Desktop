module Data.Config
    exposing
        ( Config
        , assetSrc
        , fromFlags
        )

import Data.Flags exposing (Flags)
import Id exposing (Id)
import Keyboard.Extra.Browser
    exposing
        ( Browser(FireFox)
        )
import Random.Pcg as Random exposing (Seed)


{-|

    Formal term : Config
    A config is for values that dont change
    during run time, but cant be hardcoded

-}
type alias Config =
    { sessionId : Id
    , browser : Browser
    , mountPath : String
    , logoSrc : String
    , videoSrc : String
    }


fromFlags : Flags -> ( Config, Seed )
fromFlags flags =
    let
        ( sessionId, seed ) =
            Random.step Id.generator flags.seed
    in
    (,)
        { sessionId = sessionId
        , browser = flags.browser
        , mountPath = flags.mountPath
        , logoSrc = "splash-image.png"
        , videoSrc = "splash-video.mp4"
        }
        seed


assetSrc : Config -> (Config -> String) -> String
assetSrc config assetFunc =
    config.mountPath ++ "/" ++ assetFunc config
