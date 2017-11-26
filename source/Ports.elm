port module Ports exposing (..)

import Data.Keys as Keys
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


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
    , name : String
    , password : String
    }


fromKeyValues : String -> List ( String, Value ) -> Cmd msg
fromKeyValues type_ keyValues =
    [ "type" := Encode.string type_
    , "payload" := Encode.object keyValues
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


encodeConfig : Keys.Config -> Value
encodeConfig =
    Keys.encodeConfig >> Encode.encode 0 >> Encode.string


send : JsMsg -> Cmd msg
send msg =
    case msg of
        Logout ->
            noPayload "log out"

        OpenPaintApp ->
            noPayload "open paint app"

        Register { email, name, password } ->
            [ "email" := Encode.string email
            , "name" := Encode.string name
            , "password" := Encode.string password
            , "keyConfig" := encodeConfig Keys.defaultConfig
            ]
                |> fromKeyValues "register"

        Login email password ->
            [ "email" := Encode.string email
            , "password" := Encode.string password
            ]
                |> fromKeyValues "log in"

        VerifyEmail email code ->
            [ "email" := Encode.string email
            , "code" := Encode.string code
            ]
                |> fromKeyValues "verify email"

        GetUserAttributes ->
            noPayload "get user attributes"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
