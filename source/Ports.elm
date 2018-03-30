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
    | OpenInNewWindow String
    | DeleteDrawing Id
    | Register RegistrationPayload
    | Login String String
    | VerifyEmail String String
    | GetUserAttributes
    | GetDrawings
    | ForgotPassword String
    | ResetPassword String String String
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
            noPayload "logOut"

        OpenPaintApp ->
            noPayload "openPaintApp"

        OpenPaintAppWithParams queryString ->
            "openPaintAppWithParams"
                |> withPayload (Encode.string queryString)

        OpenUrlInPaintApp url ->
            "openUrlInPaintApp"
                |> withPayload (Encode.string url)

        OpenDrawingInPaintApp id ->
            "openDrawingInPaintApp"
                |> withPayload (Id.encode id)

        OpenInNewWindow url ->
            "openInNewWindow"
                |> withPayload (Encode.string url)

        DeleteDrawing id ->
            "deleteDrawing"
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
                |> fromKeyValues "logIn"

        VerifyEmail email code ->
            [ "email" := Encode.string email
            , "code" := Encode.string code
            ]
                |> fromKeyValues "verifyEmail"

        GetUserAttributes ->
            noPayload "getUserAttributes"

        GetDrawings ->
            noPayload "getDrawings"

        ForgotPassword email ->
            "forgotPassword"
                |> withPayload (Encode.string email)

        ResetPassword email code password ->
            [ "email" := Encode.string email
            , "code" := Encode.string code
            , "password" := Encode.string password
            ]
                |> fromKeyValues "resetPassword"

        Track payload ->
            "track"
                |> withPayload (Tracking.encode payload)


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
