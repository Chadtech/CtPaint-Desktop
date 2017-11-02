port module Ports exposing (..)

import Json.Encode as Encode exposing (Value)
import Util exposing ((:=))


-- TYPES --


type JsMsg
    = Logout
    | OpenPaintApp
    | Register RegistrationPayload
    | Login String String
    | VerifyEmail String String
    | GetUserAttributes


type alias RegistrationPayload =
    { email : String
    , username : String
    , password : String
    }


withPayload : String -> List ( String, Value ) -> Cmd msg
withPayload type_ payload =
    [ "type" := Encode.string type_
    , "payload" := Encode.object payload
    ]
        |> Encode.object
        |> toJs


noPayload : String -> Cmd msg
noPayload type_ =
    [ "type" := Encode.string type_
    , "payload" := Encode.null
    ]
        |> Encode.object
        |> toJs


send : JsMsg -> Cmd msg
send msg =
    case msg of
        Logout ->
            noPayload "log out"

        OpenPaintApp ->
            noPayload "open paint app"

        Register { email, username, password } ->
            [ "email" := Encode.string email
            , "username" := Encode.string username
            , "password" := Encode.string password
            ]
                |> withPayload "register"

        Login email password ->
            [ "email" := Encode.string email
            , "password" := Encode.string password
            ]
                |> withPayload "log in"

        VerifyEmail email code ->
            [ "email" := Encode.string email
            , "code" := Encode.string code
            ]
                |> withPayload "verify email"

        GetUserAttributes ->
            noPayload "get user attributes"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
