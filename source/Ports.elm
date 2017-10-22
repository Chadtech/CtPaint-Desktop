port module Ports exposing (..)

import Json.Encode as Encode exposing (Value)
import Util exposing ((:=))


-- TYPES --


type JsMsg
    = EndSession
    | OpenPaintApp
    | Register RegistrationPayload
    | Login String String
    | VerifyEmail String String


type alias RegistrationPayload =
    { email : String
    , username : String
    , password : String
    }


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

        Register { email, username, password } ->
            [ "email" := Encode.string email
            , "username" := Encode.string username
            , "password" := Encode.string password
            ]
                |> Encode.object
                |> toMsg "register"

        Login email password ->
            [ "email" := Encode.string email
            , "password" := Encode.string password
            ]
                |> Encode.object
                |> toMsg "login"

        VerifyEmail email code ->
            [ "email" := Encode.string email
            , "code" := Encode.string code
            ]
                |> Encode.object
                |> toMsg "verify email"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
