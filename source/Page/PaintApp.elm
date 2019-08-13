module Page.PaintApp exposing
    ( Model
    , getSession
    , init
    , view
    )

import Data.Document exposing (Document)
import Session exposing (Session)
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Model
init session =
    { session = session }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document msg
view model =
    { title = Nothing
    , body =
        [ Text.fromString "Paint App!!" ]
    }
