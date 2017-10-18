module Types exposing (..)

import Ports exposing (ReceiveMsg(..))


type Msg
    = UpdateField String
    | EnterHappened
    | HandleJsMsg (Result String ReceiveMsg)


type alias Model =
    { field : String
    , timesEnterWasPressed : Int
    }



-- INIT --


init : Model
init =
    { field = ""
    , timesEnterWasPressed = 0
    }
