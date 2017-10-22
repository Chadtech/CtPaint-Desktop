module Model exposing (..)

import Data.Session exposing (Session)
import Page exposing (Page(..))


type alias Model =
    { session : Maybe Session
    , page : Page
    }
