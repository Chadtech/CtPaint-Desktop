module Main exposing (..)

import Html
import Ports exposing (ReceiveMsg(..), SendMsg(..))
import Types exposing (Model, Msg(..), init)
import Util exposing ((&))
import View exposing (view)


-- MAIN --


main : Program Never Model Msg
main =
    Html.program
        { init = ( init, Cmd.none )
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


handleRecieveMsg : ReceiveMsg -> Model -> ( Model, Cmd Msg )
handleRecieveMsg receiveMsg model =
    case receiveMsg of
        ConsoleLogHappened ->
            model & Cmd.none
