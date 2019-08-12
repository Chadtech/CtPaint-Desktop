module Data.User exposing
    ( Model(..)
    , User
    , decoder
    , getEmail
    , isLoggedIn
    , userDecoder
    )

import Data.Browser exposing (Browser)
import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil


type Model
    = Offline
    | LoggedOut
    | LoggingIn
    | LoggedIn User


type alias User =
    { email : String
    , name : String
    , profilePic : Maybe String
    }



-- DECODER --


decoder : Browser -> Decoder Model
decoder browser =
    [ Decode.null LoggedOut
    , Decode.string |> Decode.andThen offlineDecoder
    , Decode.map LoggedIn userDecoder
    ]
        |> Decode.oneOf


offlineDecoder : String -> Decoder Model
offlineDecoder str =
    if str == "offline" then
        Decode.succeed Offline

    else
        Decode.fail "not offline"


userDecoder : Decoder User
userDecoder =
    Decode.succeed User
        |> DecodeUtil.apply (Decode.field "email" Decode.string)
        |> DecodeUtil.apply (Decode.field "name" Decode.string)
        |> DecodeUtil.apply profilePicDecoder


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



-- Helpers --


getEmail : Model -> Maybe String
getEmail model =
    case model of
        LoggedIn user ->
            Just user.email

        _ ->
            Nothing


isLoggedIn : Model -> Bool
isLoggedIn model =
    case model of
        LoggedIn _ ->
            True

        _ ->
            False
