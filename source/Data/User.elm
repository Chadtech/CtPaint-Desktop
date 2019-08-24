module Data.User exposing
    ( User(..)
    , decoder
    , getEmail
    , isLoggedIn
    , loggedIn
    )

import Data.Account as Account exposing (Account)
import Json.Decode as Decode exposing (Decoder)
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type User
    = User
    | Account Account



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : Decoder User
decoder =
    [ Decode.null User
    , DecodeUtil.matchString "offline" User
    , Decode.map Account Account.decoder
    ]
        |> Decode.oneOf


getEmail : User -> Maybe String
getEmail model =
    case model of
        Account user ->
            Just user.email

        _ ->
            Nothing


isLoggedIn : User -> Bool
isLoggedIn model =
    case model of
        Account _ ->
            True

        _ ->
            False


loggedIn : Account -> User
loggedIn =
    Account
