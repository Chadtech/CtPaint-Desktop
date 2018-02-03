module Data.Config
    exposing
        ( Config
        , error
        , fromFlags
        )

import Data.Flags exposing (Flags)
import Id exposing (Id)
import Keyboard.Extra.Browser
    exposing
        ( Browser(FireFox)
        )
import Random.Pcg as Random exposing (Seed)


type alias Config =
    { sessionId : Id
    , browser : Browser
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
        }
        seed


error : Config
error =
    { sessionId = Id.fromString "NO ID"
    , browser = FireFox
    }
