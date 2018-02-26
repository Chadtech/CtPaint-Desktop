module Msg exposing (..)

import Data.Drawing as Drawing exposing (Drawing)
import Data.Taco exposing (Taco)
import Data.User as User exposing (User)
import Json.Decode as Decode
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import Nav
import Page.Contact as Contact
import Page.Error as Error
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Pricing as Pricing
import Page.Register as Register
import Page.RoadMap as RoadMap
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
    | RoadMapMsg RoadMap.Msg
    | ContactMsg Contact.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg
    | ForgotPasswordMsg ForgotPassword.Msg
    | LogoutMsg Logout.Msg
    | VerifyMsg Verify.Msg
    | ErrorMsg Error.Msg
    | NavMsg Nav.Msg
    | SplashMsg Splash.Msg
    | OfflineMsg Offline.Msg
    | SettingsMsg Settings.Msg
    | InitDrawingMsg InitDrawing.Msg
    | DrawingsLoaded (List Drawing)
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = UnrecognizedType String
    | FailedToDecoderUser String
    | Other String


decode : Taco -> Value -> Msg
decode taco json =
    case decodeValue (decoder taco) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Taco -> Decoder Msg
decoder taco =
    Decode.field "type" Decode.string
        |> Decode.andThen (toMsg taco)


toMsg : Taco -> String -> Decoder Msg
toMsg taco type_ =
    case type_ of
        "login succeeded" ->
            userDecoder taco
                |> Decode.map LogInSucceeded

        "login failed" ->
            payload Decode.string
                |> Decode.map (LoginMsg << Login.LoginFailed)

        "logout succeeded" ->
            Decode.succeed LogOutSucceeded

        "logout failed" ->
            payload Decode.string
                |> Decode.map LogOutFailed

        "verification succeeded" ->
            VerifyMsg Verify.Succeeded
                |> Decode.succeed

        "verification failed" ->
            payload Decode.string
                |> Decode.map (Verify.Failed >> VerifyMsg)

        "registration succeeded" ->
            payload Decode.string
                |> Decode.map (Register.Succeeded >> RegisterMsg)

        "registration failed" ->
            payload Decode.string
                |> Decode.map (Register.Other >> Register.Failed >> RegisterMsg)

        "drawings loaded" ->
            payload (Decode.list Drawing.decoder)
                |> Decode.map DrawingsLoaded

        _ ->
            Decode.fail ("Unrecognized Js Msg : " ++ type_)


userDecoder : Taco -> Decoder User
userDecoder taco =
    User.userDecoder taco.config.browser


decodePayload : Decoder a -> Value -> Result String a
decodePayload decoder json =
    Decode.decodeValue (Decode.field "payload" decoder) json


payload : Decoder a -> Decoder a
payload =
    Decode.field "payload"


decodeStringPayload : Value -> Result String String
decodeStringPayload =
    decodePayload Decode.string
