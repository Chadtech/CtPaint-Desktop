module Desktop exposing (..)

import Data.Flags as Flags exposing (Flags)
import Data.Taco as Taco exposing (Taco)
import Data.User as User
import Html exposing (Html)
import Html.Custom
import Html.InitDrawing
import Html.Main
import Id
import Json.Decode as Decode exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Page exposing (HoldUp(..), Page(..), Problem(..))
import Page.About as About
import Page.AllowanceExceeded as AllowanceExceeded
import Page.Contact as Contact
import Page.Documentation as Documentation
import Page.Error as Error
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.Loading as Loading
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
import Ports exposing (JsMsg(..))
import Return2 as R2
import Route
import Tracking exposing (Event(AppInit, AppInitFail))
import Update


-- MAIN --


main : Program Value (Result String Model) Msg
main =
    Navigation.programWithFlags
        onNavigation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


onNavigation : Location -> Msg
onNavigation =
    Route.fromLocation >> RouteChanged


update : Msg -> Result String Model -> ( Result String Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            Update.update msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> R2.withNoCmd



-- INIT --


init : Value -> Location -> ( Result String Model, Cmd Msg )
init json location =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            let
                taco =
                    Taco.fromFlags flags
            in
            { page = Blank
            , taco = taco
            }
                |> initPage location
                |> R2.addCmd (trackInit taco flags)

        Err err ->
            { sessionId = Id.fromString "ERROR"
            , email = Nothing
            , event = AppInitFail err
            }
                |> Ports.Track
                |> Ports.send
                |> R2.withModel (Err err)


initPage : Location -> Model -> ( Result String Model, Cmd Msg )
initPage location model =
    Update.update (onNavigation location) model
        |> Tuple.mapFirst Ok


trackInit : Taco -> Flags -> Cmd Msg
trackInit taco flags =
    { isMac = flags.isMac
    , browser = flags.browser
    , buildNumber = flags.buildNumber
    }
        |> AppInit
        |> Ports.track taco



-- SUBSCRIPTIONS --


subscriptions : Result String Model -> Sub Msg
subscriptions result =
    case result of
        Ok model ->
            Ports.fromJs (Msg.decode model.taco)

        Err _ ->
            Sub.none



-- VIEW --


view : Result String Model -> Html Msg
view result =
    case result of
        Ok model ->
            viewModel model

        Err err ->
            errorView "Something went wrong with this apps initialization."


errorView : String -> Html Msg
errorView =
    Error.view >> Html.map ErrorMsg


viewWithNav : Model -> (subMsg -> Msg) -> List (Html subMsg) -> Html Msg
viewWithNav model toMsg =
    List.map (Html.map toMsg)
        >> Html.Main.viewWithNav model


viewModel : Model -> Html Msg
viewModel model =
    case model.page of
        Page.Home subModel ->
            case model.taco.user of
                User.LoggedIn user ->
                    subModel
                        |> Home.view model.taco user
                        |> viewWithNav model HomeMsg

                _ ->
                    errorView "Something went wrong with your authentication, sorry"

        Page.InitDrawing subModel ->
            [ Html.Custom.header
                { text = "open ctpaint"
                , closability = Html.Custom.NotClosable
                }
            , Html.InitDrawing.view subModel
            ]
                |> Html.Custom.cardSolitary []
                |> List.singleton
                |> Html.Custom.background []
                |> List.singleton
                |> viewWithNav model InitDrawingMsg

        Page.About ->
            About.view model.taco
                |> viewWithNav model identity

        Page.Documentation ->
            Documentation.view model.taco
                |> viewWithNav model identity

        Page.Pricing ->
            Pricing.view model.taco
                |> viewWithNav model PricingMsg

        Page.RoadMap subModel ->
            subModel
                |> RoadMap.view model.taco
                |> viewWithNav model RoadMapMsg

        Page.Contact subModel ->
            subModel
                |> Contact.view
                |> viewWithNav model ContactMsg

        Page.Offline ->
            Offline.view
                |> viewWithNav model OfflineMsg

        Page.Splash ->
            Splash.view model.taco
                |> viewWithNav model SplashMsg

        Page.Settings subModel ->
            subModel
                |> Settings.view
                |> viewWithNav model SettingsMsg

        Page.Register subModel ->
            [ Register.view subModel ]
                |> viewWithNav model RegisterMsg

        Page.Login subModel ->
            [ Login.view subModel ]
                |> viewWithNav model LoginMsg

        Page.ForgotPassword subModel ->
            [ ForgotPassword.view subModel ]
                |> viewWithNav model ForgotPasswordMsg

        Page.ResetPassword subModel ->
            [ ResetPassword.view subModel ]
                |> viewWithNav model ResetPasswordMsg

        Page.Logout subModel ->
            Html.map LogoutMsg (Logout.view subModel)

        Page.Verify subModel ->
            Html.map VerifyMsg (Verify.view subModel)

        Page.AllowanceExceeded ->
            [ AllowanceExceeded.view ]
                |> viewWithNav model AllowanceExceededMsg

        Page.Loading holdUp ->
            Loading.view holdUp

        Error InvalidUrl ->
            errorView "Sorry, something is wrong with your url"

        Blank ->
            errorView "Somehow no page was loaded"
