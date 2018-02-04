module Desktop exposing (..)

import Data.Flags as Flags
import Data.Taco as Taco
import Html exposing (Html)
import Html.Main
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
import Page.Offline as Offline
import Page.Register as Register
import Page.Splash as Splash
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Route
import Tuple.Infix exposing ((&))
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
            Err err & Cmd.none



-- INIT --


init : Value -> Location -> ( Result String Model, Cmd Msg )
init json location =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            { page = Error NoPageLoaded
            , taco = Taco.fromFlags flags
            }
                |> initPage location

        Err err ->
            Err err & Cmd.none


initPage : Location -> Model -> ( Result String Model, Cmd Msg )
initPage location model =
    Update.update (onNavigation location) model
        |> Tuple.mapFirst Ok



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
            let
                _ =
                    Debug.log "INIT ERROR" err
            in
            errorView "Something went wrong with this apps initialization."


errorView : String -> Html Msg
errorView =
    Error.view >> Html.map ErrorMsg


viewWithNav : Model -> (subMsg -> Msg) -> List (Html subMsg) -> Html Msg
viewWithNav model toMsg =
    List.map (Html.map toMsg) >> Html.Main.viewWithNav model.taco


viewModel : Model -> Html Msg
viewModel model =
    case model.page of
        Page.Home subModel ->
            subModel
                |> Home.view model.taco
                |> viewWithNav model HomeMsg

        Page.Offline ->
            Offline.view
                |> viewWithNav model OfflineMsg

        Page.Splash ->
            Splash.view
                |> viewWithNav model SplashMsg

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
            errorView "Sorry, something is wrong with your url"

        Error NoPageLoaded ->
            errorView "Somehow no page was loaded"
