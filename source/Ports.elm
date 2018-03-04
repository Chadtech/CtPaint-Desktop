port module Ports exposing (..)

import Data.Keys as Keys
import Data.Taco exposing (Taco)
import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Keyboard.Extra.Browser exposing (Browser)
import Tracking
import Tuple.Infix exposing ((:=))


-- TYPES --


type JsMsg
    = Logout
    | OpenPaintApp
    | OpenPaintAppWithParams String
    | OpenUrlInPaintApp String
    | OpenDrawingInPaintApp Id
    | DeleteDrawing Id
    | Register RegistrationPayload
    | Login String String
    | VerifyEmail String String
    | GetUserAttributes
    | GetDrawings
    | ForgotPassword String
    | Track Tracking.Payload


type alias RegistrationPayload =
    { email : String
    , name : String
    , password : String
    , browser : Browser
    , emailable : Bool
    }


track : Taco -> Tracking.Event -> Cmd msg
track taco =
    Tracking.fromTaco taco >> Track >> send


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

        OpenPaintAppWithParams queryString ->
            "open paint app with params"
                |> withPayload (Encode.string queryString)

        OpenUrlInPaintApp url ->
            "open url in paint app"
                |> withPayload (Encode.string url)

        OpenDrawingInPaintApp id ->
            "open drawing in paint app"
                |> withPayload (Id.encode id)

        DeleteDrawing id ->
            "delete drawing"
                |> withPayload (Id.encode id)

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

        ForgotPassword email ->
            "forgot password"
                |> withPayload (Encode.string email)

        Track payload ->
            "track"
                |> withPayload (Tracking.encode payload)


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
