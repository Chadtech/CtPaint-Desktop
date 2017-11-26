module Model exposing (..)

import Data.User as User
import Page exposing (Page(..))


type alias Model =
    { user : User.Model
    , page : Page
    }
