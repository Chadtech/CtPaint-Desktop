module Data.Config
    exposing
        ( Config
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
        }
        seed
