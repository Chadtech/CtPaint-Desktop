module Model
    exposing
        ( Model
        , setUser
        )

import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Page exposing (Page(..))


type alias Model =
    { page : Page
    , taco : Taco
    }


setUser : User.Model -> Model -> Model
setUser user model =
    { model
        | taco =
            Taco.setUser user model.taco
    }
