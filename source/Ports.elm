port module Ports exposing (..)

import Json.Encode as Encode exposing (Value)
import Util exposing ((:=))


type JsMsg
    = EndSession
    | OpenPaintApp


toMsg : String -> Value -> Cmd msg
toMsg type_ payload =
    [ "type" := Encode.string type_
    , "payload" := payload
    ]
        |> Encode.object
        |> toJs


noPayload : String -> Cmd msg
noPayload type_ =
    toMsg type_ Encode.null


send : JsMsg -> Cmd msg
send msg =
    case msg of
        EndSession ->
            noPayload "end session"

        OpenPaintApp ->
            noPayload "open paint app"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
