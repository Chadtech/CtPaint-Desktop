module Data.Taco exposing
    ( Taco
    , fromFlags
    , setEntities
    , setSeed
    , setUser
    )

import Data.Account as User
import Data.Config as Config exposing (Config)
import Data.Entities as Entities exposing (Entities)
import Data.Flags exposing (Flags)
import Random exposing (Seed)


{-|

    Formal term : Taco
    Some values are used only in specific contexts,
    like the Models for specific pages. Others are
    used through out the whole application. The taco
    is for storing widely used values that arent
    specific to any particular application state

-}
type alias Taco =
    { user : User.Model
    , seed : Seed
    , config : Config
    , entities : Entities
    }


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



-- HELPERS --


setUser : User.Model -> Taco -> Taco
setUser user taco =
    { taco | user = user }


setSeed : Seed -> Taco -> Taco
setSeed seed taco =
    { taco | seed = seed }


setEntities : Taco -> Entities -> Taco
setEntities taco entities =
    { taco | entities = entities }
