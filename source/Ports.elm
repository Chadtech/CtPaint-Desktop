port module Ports exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Util exposing ((:=))


type SendMsg
    = ConsoleLog String


type ReceiveMsg
    = ConsoleLogHappened


sendToJs : SendMsg -> Cmd msg
sendToJs msg =
    case msg of
        ConsoleLog str ->
            [ "type" := Encode.string "console log"
            , "payload" := Encode.string str
            ]
                |> Encode.object
                |> toJs


decodeReceiveMsg : Value -> Result String ReceiveMsg
decodeReceiveMsg json =
    Decode.decodeValue (receive json) json


receive : Value -> Decoder ReceiveMsg
receive json =
    Decode.field "type" Decode.string
        |> Decode.andThen (receiveMsgDecoder json)


receiveMsgDecoder : Value -> String -> Decoder ReceiveMsg
receiveMsgDecoder json string =
    case string of
        "console log happened" ->
            Decode.succeed ConsoleLogHappened

        _ ->
            Decode.fail "Not a valid receive msg type"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
