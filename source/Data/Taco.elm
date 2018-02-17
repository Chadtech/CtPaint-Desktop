module Data.Taco
    exposing
        ( Taco
        , fromFlags
        , setSeed
        , setUser
        )

import Data.Config as Config exposing (Config)
import Data.Entities as Entities exposing (Entities)
import Data.Flags exposing (Flags)
import Data.User as User
import Random.Pcg as Random exposing (Seed)


type alias Taco =
    { user : User.Model
    , seed : Seed
    , config : Config
    , entities : Entities
    }


setUser : User.Model -> Taco -> Taco
setUser user taco =
    { taco | user = user }


setSeed : Seed -> Taco -> Taco
setSeed seed taco =
    { taco | seed = seed }


fromFlags : Flags -> Taco
fromFlags flags =
    let
        ( config, seed ) =
            Config.fromFlags flags
    in
    { user = flags.user
    , seed = seed
    , config = config
    , entities = Entities.empty
    }
