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
import Ports exposing (JsMsg(..))
import Route
import Util exposing ((&))


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
    { session = Session.decode json
    , page = Home {}
    }
        & Cmd.none



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

        Error InvalidUrl ->
            Error.view "Sorry, something is wrong with your url"



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetRoute maybeRoute ->
            model & Cmd.none

        InvalidJsMsg err ->
            model & Cmd.none

        HomeMsg subMsg ->
            case model.page of
                Home subModel ->
                    incorporateHome
                        (Home.update subMsg subModel)
                        model

                _ ->
                    model & Cmd.none

        Noop ->
            model & Cmd.none


incorporateHome : ( Home.Model, Home.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateHome ( homeModel, reply ) model =
    case reply of
        Home.NoReply ->
            { model | page = Home homeModel } & Cmd.none
