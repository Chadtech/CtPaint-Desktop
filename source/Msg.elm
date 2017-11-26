module Msg exposing (..)

import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder, Value)
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.Verify as Verify
import Route exposing (Route(..))


type Msg
    = RouteChanged (Maybe Route)
    | LogInSucceeded User
    | LogOutSucceeded
    | LogOutFailed String
    | InvalidJsMsg JsMsgProblem
    | HomeMsg Home.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg
    | LogoutMsg Logout.Msg
    | VerifyMsg Verify.Msg
    | Navigate Route


type JsMsgProblem
    = PayloadDecodeFailed String
    | TypeDecodeFailed String
    | UnrecognizedType String


decode : Value -> Msg
decode json =
    case Decode.decodeValue typeDecoder json of
        Ok "login succeeded" ->
            case decodePayload User.userDecoder json of
                Ok user ->
                    LogInSucceeded user

                Err err ->
                    InvalidJsMsg (PayloadDecodeFailed err)

        Ok "login failed" ->
            case decodeStringPayload json of
                Ok err ->
                    LoginMsg (Login.LoginFailed err)

                Err err ->
                    LoginMsg (Login.LoginFailed err)

        Ok "logout succeeded" ->
            LogOutSucceeded

        Ok "logout failed" ->
            case decodeStringPayload json of
                Ok err ->
                    LogOutFailed err

                Err err ->
                    LogOutFailed err

        Ok "verification succeeded" ->
            VerifyMsg Verify.Succeeded

        Ok "verification failed" ->
            case decodeStringPayload json of
                Ok err ->
                    VerifyMsg (Verify.Failed err)

                Err err ->
                    VerifyMsg (Verify.Failed err)

        Ok "registration succeeded" ->
            case decodeStringPayload json of
                Ok email ->
                    RegisterMsg (Register.Succeeded email)

                Err err ->
                    Register.CouldntDecodeSuccess
                        |> Register.Failed
                        |> RegisterMsg

        Ok "registration failed" ->
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

        Ok type_ ->
            InvalidJsMsg (UnrecognizedType type_)

        Err err ->
            InvalidJsMsg (TypeDecodeFailed err)


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
