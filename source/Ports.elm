port module Ports exposing (..)

import Json.Encode as Encode exposing (Value)
import Util exposing ((:=))


type JsMsg
    = ConsoleLog String


send : JsMsg -> Cmd msg
send msg =
    case msg of
        ConsoleLog str ->
            [ "type" := Encode.string "console log"
            , "payload" := Encode.string str
            ]
                |> Encode.object
                |> toJs


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
