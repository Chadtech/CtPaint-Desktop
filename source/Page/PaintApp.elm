module Page.PaintApp exposing
    ( Model
    , getSession
    , init
    , navigationIsOkay
    , view
    )

import Data.Document exposing (Document)
import Data.User exposing (User)
import Route exposing (Route)
import Session exposing (Session)
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session User
    , pendingNavigation : Maybe Route
    }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session User -> Model
init session =
    { session = session
    , pendingNavigation = Nothing
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session User
getSession =
    .session


navigationIsOkay : Model -> Bool
navigationIsOkay model =
    False



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document msg
view model =
    { title = Nothing
    , body =
        [ Text.fromString "Paint App!!" ]
    }
