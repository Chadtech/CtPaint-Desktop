module Msg exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Page.Home as Home
import Page.Login as Login
import Page.Register as Register
import Page.Verify as Verify
import Route exposing (Route(..))


type Msg
    = SetRoute (Maybe Route)
    | LoggedIn
    | InvalidJsMsg JsMsgProblem
    | HomeMsg Home.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg
    | VerifyMsg Verify.Msg
    | Navigate Route


type JsMsgProblem
    = CouldntDecode String
    | UnrecognizedType String


decode : Value -> Msg
decode json =
    case Decode.decodeValue typeDecoder json of
        Ok "login success" ->
            LoggedIn

        Ok "login fail" ->
            case decodeStringPayload json of
                Ok err ->
                    LoginMsg (Login.LoginFailed err)

                Err err ->
                    LoginMsg (Login.LoginFailed err)

        Ok "verification success" ->
            VerifyMsg Verify.Succeeded

        Ok "verification fail" ->
            case decodeStringPayload json of
                Ok err ->
                    VerifyMsg (Verify.Failed err)

                Err err ->
                    VerifyMsg (Verify.Failed err)

        Ok type_ ->
            InvalidJsMsg (UnrecognizedType type_)

        Err err ->
            InvalidJsMsg (CouldntDecode err)


decodeStringPayload : Value -> Result String String
decodeStringPayload json =
    Decode.decodeValue stringPayload json


stringPayload : Decoder String
stringPayload =
    Decode.field "payload" Decode.string


typeDecoder : Decoder String
typeDecoder =
    Decode.field "type" Decode.string
