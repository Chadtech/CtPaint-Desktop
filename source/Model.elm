module Model exposing (..)

import Data.User exposing (User)
import Page exposing (Page(..))


type alias Model =
    { user : Maybe User
    , page : Page
    }
