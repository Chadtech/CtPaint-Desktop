module Data.Account exposing
    ( Account
    , None
    , decoder
    , getName
    , getProfilePic
    , none
    )

import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-- TODO rename this Account, and rename Viewer "User"
-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Account =
    { email : String
    , name : String
    , profilePic : Maybe String
    }


{-| As in "no user"
-}
type None
    = None



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


none : None
none =
    None


decoder : Decoder Account
decoder =
    Decode.succeed Account
        |> DecodeUtil.apply (Decode.field "email" Decode.string)
        |> DecodeUtil.apply (Decode.field "name" Decode.string)
        |> DecodeUtil.apply profilePicDecoder


getName : Account -> String
getName =
    .name


getProfilePic : Account -> Maybe String
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
