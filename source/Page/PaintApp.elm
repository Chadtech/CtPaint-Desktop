module Page.PaintApp exposing
    ( Model
    , getSession
    , getUser
    , init
    , mapSession
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
    { session : Session
    , user : User
    , pendingNavigation : Maybe Route
    }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> Model
init session user =
    { session = session
    , user = user
    , pendingNavigation = Nothing
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


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
