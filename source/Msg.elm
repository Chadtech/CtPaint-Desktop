module Msg exposing (..)

import Data.Taco exposing (Taco)
import Data.User as User exposing (User)
import Json.Decode as Decode
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import Nav
import Page.Error as Error
import Page.Home as Home
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Pricing as Pricing
import Page.Register as Register
import Page.Settings as Settings
import Page.Splash as Splash
import Page.Verify as Verify
import Route exposing (Route(..))


type Msg
    = RouteChanged (Maybe Route)
    | LogInSucceeded User
    | LogOutSucceeded
    | LogOutFailed String
    | HomeMsg Home.Msg
    | PricingMsg Pricing.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg
    | LogoutMsg Logout.Msg
    | VerifyMsg Verify.Msg
    | ErrorMsg Error.Msg
    | NavMsg Nav.Msg
    | SplashMsg Splash.Msg
    | OfflineMsg Offline.Msg
    | SettingsMsg Settings.Msg
    | InitDrawingMsg InitDrawing.Msg
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = UnrecognizedType String
    | FailedToDecoderUser String
    | Other String


decode : Taco -> Value -> Msg
decode taco json =
    case decodeValue (decoder taco json) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Taco -> Value -> Decoder Msg
decoder taco json =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (Decode.succeed << toMsg taco json)


toMsg : Taco -> Value -> String -> Msg
toMsg taco json type_ =
    case type_ of
        "login succeeded" ->
            let
                userDecoder =
                    User.userDecoder taco.config.browser
            in
            case decodePayload userDecoder json of
                Ok user ->
                    LogInSucceeded user

                Err err ->
                    MsgDecodeFailed (FailedToDecoderUser err)

        "login failed" ->
            case decodeStringPayload json of
                Ok err ->
                    LoginMsg (Login.LoginFailed err)

                Err err ->
                    LoginMsg (Login.LoginFailed err)

        "logout succeeded" ->
            LogOutSucceeded

        "logout failed" ->
            case decodeStringPayload json of
                Ok err ->
                    LogOutFailed err

                Err err ->
                    LogOutFailed err

        "verification succeeded" ->
            VerifyMsg Verify.Succeeded

        "verification failed" ->
            case decodeStringPayload json of
                Ok err ->
                    VerifyMsg (Verify.Failed err)

                Err err ->
                    VerifyMsg (Verify.Failed err)

        "registration succeeded" ->
            case decodeStringPayload json of
                Ok email ->
                    RegisterMsg (Register.Succeeded email)

                Err err ->
                    Register.CouldntDecodeSuccess
                        |> Register.Failed
                        |> RegisterMsg

        "registration failed" ->
            case decodeStringPayload json of
                Ok err ->
                    err
                        |> Register.Other
                        |> Register.Failed
                        |> RegisterMsg

                Err err ->
                    Register.CouldntDecodeFail
                        |> Register.Failed
                        |> RegisterMsg

        type_ ->
            MsgDecodeFailed (UnrecognizedType type_)


decodePayload : Decoder a -> Value -> Result String a
decodePayload decoder json =
    Decode.decodeValue (Decode.field "payload" decoder) json


decodeStringPayload : Value -> Result String String
decodeStringPayload json =
    Decode.decodeValue stringPayload json


stringPayload : Decoder String
stringPayload =
    Decode.field "payload" Decode.string


typeDecoder : Decoder String
typeDecoder =
    Decode.field "type" Decode.string
