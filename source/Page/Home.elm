module Page.Home exposing (Model, State(..), init)

import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Id exposing (Id)
import Ports
import Session exposing (Session)
import Ui.InitDrawing as InitDrawing



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session User
    , state : State
    }


type State
    = SpecificDrawing (Id Drawing)
    | DeleteDrawing (Id Drawing)
    | DidntDelete (Id Drawing)
    | LoadingAllDrawings
    | LoadingDrawing
    | DrawingsView
    | Deleting
    | Deleted String
    | NewDrawing InitDrawing.Model



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session User -> ( Model, Cmd msg )
init session =
    ( { session = session
      , state = LoadingAllDrawings
      }
    , Ports.payload "get drawings"
        |> Ports.send
    )
