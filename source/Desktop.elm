module Desktop exposing (..)

import Data.Flags as Flags
import Data.User as User
import Html exposing (Html)
import Json.Decode as Decode exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Page exposing (HoldUp(..), Page(..), Problem(..))
import Page.Error as Error
import Page.Home as Home
import Page.Loading as Loading
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Route
import Tuple.Infix exposing ((&))
import Update exposing (update)


-- MAIN --


main : Program Value Model Msg
main =
    Navigation.programWithFlags
        (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT --


init : Value -> Location -> ( Model, Cmd Msg )
init json location =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            { user = flags.user
            , page = Error NoPageLoaded
            }
                |> initPage location

        Err err ->
            { user = User.NoSession
            , page = Error (FlagsDecoderFailed err)
            }
                & Cmd.none


initPage : Location -> Model -> ( Model, Cmd Msg )
initPage =
    Route.fromLocation >> SetRoute >> update



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.fromJs Msg.decode



-- VIEW --


view : Model -> Html Msg
view model =
    case model.page of
        Page.Home subModel ->
            Html.map HomeMsg (Home.view subModel)

        Page.Settings ->
            Html.text ""

        Page.Register subModel ->
            Html.map RegisterMsg (Register.view subModel)

        Page.Login subModel ->
            Html.map LoginMsg (Login.view subModel)

        Page.Logout subModel ->
            Html.map LogoutMsg (Logout.view subModel)

        Page.Verify subModel ->
            Html.map VerifyMsg (Verify.view subModel)

        Page.Loading holdUp ->
            Loading.view holdUp

        Error InvalidUrl ->
            Error.view "Sorry, something is wrong with your url"

        Error NoPageLoaded ->
            Error.view "Somehow no page was loaded"

        Error (FlagsDecoderFailed err) ->
            Error.view ("Something went wrong with this apps initialization. Here is the error :" ++ err)

        Error Offline ->
            Error.view "It looks like you arent connected to the internet."
