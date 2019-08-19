module Data.Viewer exposing
    ( Viewer(..)
    , decoder
    , getEmail
    , isLoggedIn
    , loggedIn
    )

import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Viewer
    = Offline
    | Viewer
    | User User



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : Decoder Viewer
decoder =
    let
        offlineDecoder : String -> Decoder Viewer
        offlineDecoder str =
            if str == "offline" then
                Decode.succeed Offline

            else
                Decode.fail "not offline"
    in
    [ Decode.null Viewer
    , Decode.string
        |> Decode.andThen offlineDecoder
    , Decode.map User User.decoder
    ]
        |> Decode.oneOf


getEmail : Viewer -> Maybe String
getEmail model =
    case model of
        User user ->
            Just user.email

        _ ->
            Nothing


isLoggedIn : Viewer -> Bool
isLoggedIn model =
    case model of
        User _ ->
            True

        _ ->
            False


loggedIn : User -> Viewer
loggedIn =
    User
