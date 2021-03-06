module Msg
    exposing
        ( Msg(..)
        , decode
        )

import Data.Drawing as Drawing exposing (Drawing)
import Data.Taco exposing (Taco)
import Data.User as User exposing (User)
import Html.InitDrawing as InitDrawing
import Id exposing (Id)
import Json.Decode as Decode
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import Json.Decode.Pipeline as JDP
import Nav
import Page.AllowanceExceeded as AllowanceExceeded
import Page.Contact as Contact
import Page.Error as Error
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Pricing as Pricing
import Page.Register as Register
import Page.ResetPassword as ResetPassword
import Page.RoadMap as RoadMap
import Page.Settings as Settings
import Page.Splash as Splash
import Page.Verify as Verify
import Route exposing (Route(..))


{-|

    Msgs represent things that can happen in
    the application, so for that reason they
    are always named after what happened rather
    than what the application needs to do (so,
    "RouteChanged" instead of "SetRoute").

    Furthermore this application uses Msgs in
    tracking too. Every page has an update
    function and a track function. When a
    Msg comes in it is passed into the update
    function and the track function. Most Msgs
    have a tracking event.

-}



-- TYPE --


type Msg
    = RouteChanged (Result String Route)
    | LogInSucceeded User
    | LogOutSucceeded
    | HomeMsg Home.Msg
    | PricingMsg Pricing.Msg
    | RoadMapMsg RoadMap.Msg
    | ContactMsg Contact.Msg
    | RegisterMsg Register.Msg
    | LoginMsg Login.Msg
    | ForgotPasswordMsg ForgotPassword.Msg
    | ResetPasswordMsg ResetPassword.Msg
    | LogoutMsg Logout.Msg
    | VerifyMsg Verify.Msg
    | ErrorMsg Error.Msg
    | NavMsg Nav.Msg
    | SplashMsg Splash.Msg
    | OfflineMsg Offline.Msg
    | SettingsMsg Settings.Msg
    | InitDrawingMsg InitDrawing.Msg
    | AllowanceExceededMsg AllowanceExceeded.Msg
    | DrawingsLoaded (List Drawing)
    | DrawingDeleted (Result ( Id, String ) Id)
    | MsgDecodeFailed String String


{-|

    Decoding is for decoding Msgs that
    come in through the ports

-}



-- DECODER --


decode : Taco -> Value -> Msg
decode taco json =
    case decodeValue (decoder taco) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed err (getType json)


getType : Value -> String
getType json =
    case decodeValue typeDecoder json of
        Ok title ->
            title

        Err err ->
            "Error : " ++ err


decoder : Taco -> Decoder Msg
decoder taco =
    typeDecoder
        |> Decode.andThen (payload << toMsg taco)


typeDecoder : Decoder String
typeDecoder =
    Decode.field "type" Decode.string


toMsg : Taco -> String -> Decoder Msg
toMsg taco type_ =
    case type_ of
        "login succeeded" ->
            userDecoder taco
                |> Decode.map LogInSucceeded

        "login failed" ->
            Decode.string
                |> Decode.map (LoginMsg << Login.LoginFailed)

        "logout succeeded" ->
            Decode.succeed LogOutSucceeded

        "logout failed" ->
            Decode.string
                |> Decode.map (LogoutMsg << Logout.LogoutFailed)

        "verification succeeded" ->
            VerifyMsg Verify.Succeeded
                |> Decode.succeed

        "verification failed" ->
            Decode.string
                |> Decode.map (Verify.Failed >> VerifyMsg)

        "registration succeeded" ->
            Decode.string
                |> Decode.map (Register.Succeeded >> RegisterMsg)

        "registration failed" ->
            Decode.string
                |> Decode.map
                    (Register.Other >> Register.Failed >> RegisterMsg)

        "drawings loaded" ->
            Decode.list Drawing.decoder
                |> Decode.map DrawingsLoaded

        "delete succeeded" ->
            Id.decoder
                |> Decode.map (Ok >> DrawingDeleted)

        "delete failed" ->
            JDP.decode (,)
                |> JDP.required "id" Id.decoder
                |> JDP.required "error" Decode.string
                |> Decode.map (Err >> DrawingDeleted)

        "forgot password sent" ->
            ForgotPassword.succeeded
                |> ForgotPasswordMsg
                |> Decode.succeed

        "forgot password failed" ->
            Decode.string
                |> Decode.map
                    (ForgotPassword.failed >> ForgotPasswordMsg)

        "reset password succeeded" ->
            ResetPassword.succeeded
                |> ResetPasswordMsg
                |> Decode.succeed

        "reset password failed" ->
            Decode.string
                |> Decode.map
                    (ResetPassword.failed >> ResetPasswordMsg)

        "user update succeeded" ->
            Settings.succeeded
                |> SettingsMsg
                |> Decode.succeed

        "user update failed" ->
            Decode.string
                |> Decode.map
                    (Settings.failed >> SettingsMsg)

        _ ->
            Decode.fail ("Unrecognized Js Msg : " ++ type_)


userDecoder : Taco -> Decoder User
userDecoder taco =
    User.userDecoder taco.config.browser


payload : Decoder a -> Decoder a
payload =
    Decode.field "payload"
