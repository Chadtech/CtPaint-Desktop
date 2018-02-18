module Model
    exposing
        ( Model
        , mixinSeed
        , return
        , return2
        , return3
        , setSeed
        , setUser
        )

import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Page exposing (Page(..))
import Random.Pcg exposing (Seed)
import Tuple3


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


return : (a -> Page) -> Model -> a -> Model
return pageCtor model pageModel =
    { model | page = pageCtor pageModel }


return2 : (a -> Page) -> Model -> ( a, b ) -> ( Model, b )
return2 pageCtor model =
    Tuple.mapFirst (return pageCtor model)


return3 : (a -> Page) -> Model -> ( a, b, c ) -> ( Model, b, c )
return3 pageCtor model =
    Tuple3.mapFirst (return pageCtor model)


mixinSeed : ( Model, Seed ) -> Model
mixinSeed ( model, seed ) =
    setSeed seed model
