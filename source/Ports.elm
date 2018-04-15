port module Ports exposing (..)

import Data.Keys as Keys
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Data.User as User
import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Keyboard.Extra.Browser exposing (Browser)
import Util exposing (def)


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
    | UpdateUser UpdatePayload
    | Login String String
    | VerifyEmail String String
    | GetUserAttributes
    | GetDrawings
    | ForgotPassword String
    | ResetPassword String String String
    | RefreshPage
    | Track Tracking.Payload


type alias RegistrationPayload =
    { email : String
    , profilePicUrl : String
    , name : String
    , password : String
    , browser : Browser
    , emailable : Bool
    }


type alias UpdatePayload =
    { email : String
    , name : String
    , profilePicUrl : String
    }


sendTracking : Taco -> Maybe Tracking.Event -> Cmd msg
sendTracking { config, user } trackingEvent =
    case Tracking.namespace "desktop" trackingEvent of
        Just ( name, properties ) ->
            { sessionId = config.sessionId
            , email = User.getEmail user
            , name = name
            , properties = properties
            }
                |> Track
                |> send

        Nothing ->
            Cmd.none


fromKeyValues : String -> List ( String, Value ) -> Cmd msg
fromKeyValues type_ keyValues =
    type_
        |> withPayload (Encode.object keyValues)


noPayload : String -> Cmd msg
noPayload =
    withPayload Encode.null


withPayload : Value -> String -> Cmd msg
withPayload payload type_ =
    [ def "type" <| Encode.string type_
    , def "payload" <| payload
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

        Register { email, name, profilePicUrl, password, browser } ->
            [ def "email" <| Encode.string email
            , def "name" <| Encode.string name
            , def "profilePicUrl" <| Encode.string profilePicUrl
            , def "password" <| Encode.string password
            , def "keyConfig" <| encodeConfig browser Keys.defaultConfig
            ]
                |> fromKeyValues "register"

        UpdateUser { email, name, profilePicUrl } ->
            [ def "email" <| Encode.string email
            , def "name" <| Encode.string name
            , def "profilePicUrl" <| Encode.string profilePicUrl
            ]
                |> fromKeyValues "updateUser"

        Login email password ->
            [ def "email" <| Encode.string email
            , def "password" <| Encode.string password
            ]
                |> fromKeyValues "logIn"

        VerifyEmail email code ->
            [ def "email" <| Encode.string email
            , def "code" <| Encode.string code
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
            [ def "email" <| Encode.string email
            , def "code" <| Encode.string code
            , def "password" <| Encode.string password
            ]
                |> fromKeyValues "resetPassword"

        RefreshPage ->
            noPayload "refreshPage"

        Track payload ->
            "track"
                |> withPayload (Tracking.encode payload)


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
