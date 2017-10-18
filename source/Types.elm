module Types exposing (..)

import Json.Decode exposing (Value)
import Navigation exposing (Location)
import Ports exposing (ReceiveMsg(..))
import Route exposing (Route(..))
import Util exposing ((&))


type Msg
    = UpdateField String
    | EnterHappened
    | HandleJsMsg (Result String ReceiveMsg)
    | SetRoute (Maybe Route)


type alias Model =
    { field : String
    , timesEnterWasPressed : Int
    }



-- INIT --


init : Value -> Location -> ( Model, Cmd Msg )
init json location =
    { field = ""
    , timesEnterWasPressed = 0
    }
        & Cmd.none
