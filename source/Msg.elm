module Msg exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Page.Home as Home
import Page.Login as Login
import Page.Register as Register
import Route exposing (Route(..))


type Msg
    = SetRoute (Maybe Route)
    | Noop
    | InvalidJsMsg String
    | HomeMsg Home.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg


decode : Value -> Msg
decode json =
    case Decode.decodeValue decoder json of
        Ok msg ->
            msg

        Err err ->
            InvalidJsMsg err


decoder : Decoder Msg
decoder =
    Decode.succeed Noop
