module Model
    exposing
        ( Model
        , mixinSeed
        , setSeed
        , setUser
        )

import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Page exposing (Page(..))
import Random.Pcg exposing (Seed)


type alias Model =
    { page : Page
    , taco : Taco
    }



-- HELPERS --


setUser : User.Model -> Model -> Model
setUser user model =
    { model
        | taco =
            Taco.setUser user model.taco
    }


setSeed : Seed -> Model -> Model
setSeed seed model =
    { model
        | taco =
            Taco.setSeed seed model.taco
    }


mixinSeed : ( Model, Seed ) -> Model
mixinSeed ( model, seed ) =
    setSeed seed model
