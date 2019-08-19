module Data.Listener exposing
    ( Error(..)
    , Listener
    , Response
    , errorToString
    , for
    , getName
    , handle
    , map
    , mapError
    , mapMany
    )

import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Error error
    = DecodeError Decode.Error
    | Error error


type Listener msg
    = Listener String (Decode.Value -> msg)


type alias Response error value =
    Result (Error error) value



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


mapError : (a -> b) -> Response a v -> Response b v
mapError f response =
    case response of
        Ok value ->
            Ok value

        Err error ->
            case error of
                DecodeError decodeError ->
                    Err <| DecodeError decodeError

                Error customError ->
                    Err <| Error (f customError)


getName : Listener msg -> String
getName (Listener name _) =
    name


handle : Listener msg -> Decode.Value -> msg
handle (Listener _ handler) json =
    handler json


errorToString : (error -> String) -> Error error -> String
errorToString customToString error =
    case error of
        DecodeError decodeError ->
            DecodeUtil.errorToSanitizedString decodeError

        Error customError ->
            customToString customError


map : (a -> b) -> Listener a -> Listener b
map f (Listener name handler) =
    Listener name (f << handler)


mapMany : (a -> b) -> List (Listener a) -> List (Listener b)
mapMany f =
    List.map (map f)


for :
    { name : String
    , decoder : Decoder (Result error v)
    , handler : Result (Error error) v -> msg
    }
    -> Listener msg
for { name, decoder, handler } =
    let
        fromJson : Decode.Value -> Result (Error error) v
        fromJson json =
            case Decode.decodeValue decoder json of
                Ok v ->
                    Result.mapError Error v

                Err decodeError ->
                    decodeError
                        |> DecodeError
                        |> Err
    in
    Listener name (fromJson >> handler)
