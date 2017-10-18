module Main exposing (..)

import Json.Decode exposing (Value)
import Navigation
import Ports exposing (ReceiveMsg(..), SendMsg(..))
import Route
import Types exposing (Model, Msg(..), init)
import Util exposing ((&))
import View exposing (view)


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



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.fromJs (HandleJsMsg << Ports.decodeReceiveMsg)



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        UpdateField str ->
            { model
                | field = str
            }
                & Cmd.none

        EnterHappened ->
            { model
                | timesEnterWasPressed =
                    model.timesEnterWasPressed + 1
            }
                & Ports.sendToJs (ConsoleLog model.field)

        HandleJsMsg (Ok receiveMsg) ->
            handleRecieveMsg receiveMsg model

        HandleJsMsg (Err err) ->
            model & Cmd.none

        SetRoute maybeRoute ->
            model & Cmd.none


handleRecieveMsg : ReceiveMsg -> Model -> ( Model, Cmd Msg )
handleRecieveMsg receiveMsg model =
    case receiveMsg of
        ConsoleLogHappened ->
            model & Cmd.none
