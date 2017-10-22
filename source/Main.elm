module Main exposing (..)

import Data.Session as Session
import Html exposing (Html)
import Json.Decode exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Page exposing (Page(..), Problem(..))
import Page.Error as Error
import Page.Home as Home
import Page.Register as Register
import Ports exposing (JsMsg(..))
import Route
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
    let
        model =
            { session = Session.decode json
            , page = Error NoPageLoaded
            }

        msg =
            location
                |> Route.fromLocation
                |> SetRoute
    in
    update msg model



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.fromJs Msg.decode



-- VIEW --


view : Model -> Html Msg
view model =
    case model.page of
        Home subModel ->
            Html.map HomeMsg (Home.view subModel)

        Page.Register subModel ->
            Html.map RegisterMsg (Register.view subModel)

        Error InvalidUrl ->
            Error.view "Sorry, something is wrong with your url"

        Error NoPageLoaded ->
            Error.view "Somehow no page was loaded"

        _ ->
            Html.text "nope"
