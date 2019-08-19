module Page.PaintApp exposing
    ( Model
    , getSession
    , init
    , view
    )

import Data.Document exposing (Document)
import Data.Viewer exposing (Viewer)
import Session exposing (Session)
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session Viewer }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session Viewer -> Model
init session =
    { session = session }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session Viewer
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
