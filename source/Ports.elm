port module Ports exposing (..)

import Data.Keys as Keys
import Json.Encode as Encode exposing (Value)
import Keyboard.Extra.Browser exposing (Browser)
import Tuple.Infix exposing ((:=))


-- TYPES --


type JsMsg
    = Logout
    | OpenPaintApp
    | OpenUrlInPaintApp String
    | Register RegistrationPayload
    | Login String String
    | VerifyEmail String String
    | GetUserAttributes
    | GetDrawings


type alias RegistrationPayload =
    { email : String
    , name : String
    , password : String
    , browser : Browser
    }


fromKeyValues : String -> List ( String, Value ) -> Cmd msg
fromKeyValues type_ keyValues =
    type_
        |> withPayload (Encode.object keyValues)


noPayload : String -> Cmd msg
noPayload =
    withPayload Encode.null


withPayload : Value -> String -> Cmd msg
withPayload payload type_ =
    [ "type" := Encode.string type_
    , "payload" := payload
    ]
        |> Encode.object
        |> toJs


encodeConfig : Browser -> Keys.Config -> Value
encodeConfig browser =
    Keys.encodeConfig browser >> Encode.encode 0 >> Encode.string


send : JsMsg -> Cmd msg
send msg =
    case msg of
        Logout ->
            noPayload "log out"

        OpenPaintApp ->
            noPayload "open paint app"

        OpenUrlInPaintApp url ->
            "open url in paint app"
                |> withPayload (Encode.string url)

        Register { email, name, password, browser } ->
            [ "email" := Encode.string email
            , "name" := Encode.string name
            , "password" := Encode.string password
            , "keyConfig" := encodeConfig browser Keys.defaultConfig
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

        GetDrawings ->
            noPayload "get drawings"


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
