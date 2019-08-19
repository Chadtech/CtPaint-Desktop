module Data.User exposing
    ( User
    , decoder
    , getName
    , getProfilePic
    )

import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias User =
    { email : String
    , name : String
    , profilePic : Maybe String
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : Decoder User
decoder =
    Decode.succeed User
        |> DecodeUtil.apply (Decode.field "email" Decode.string)
        |> DecodeUtil.apply (Decode.field "name" Decode.string)
        |> DecodeUtil.apply profilePicDecoder


getName : User -> String
getName =
    .name


getProfilePic : User -> Maybe String
getProfilePic =
    .profilePic



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


profilePicDecoder : Decoder (Maybe String)
profilePicDecoder =
    let
        fromString : String -> Decoder (Maybe String)
        fromString str =
            case str of
                "" ->
                    Decode.succeed Nothing

                "NONE" ->
                    Decode.succeed Nothing

                _ ->
                    Decode.succeed (Just str)
    in
    [ Decode.string
        |> Decode.field "picture"
        |> Decode.andThen fromString
    , Decode.succeed Nothing
    ]
        |> Decode.oneOf
