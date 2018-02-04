module Comply
    exposing
        ( fromDouble
        , fromTriple
        , noReply
        )

import Reply exposing (Reply(..))
import Route
import Tuple.Infix exposing ((&))
import Util


noReply : ( model, Cmd msg ) -> ( model, Cmd msg, Reply )
noReply ( model, cmd ) =
    ( model, cmd, NoReply )


fromTriple : ( model, Cmd msg, Reply ) -> ( model, Cmd msg )
fromTriple ( model, cmd, reply ) =
    model
        & reply
        |> fromDouble
        |> Util.addCmd cmd


fromDouble : ( model, Reply ) -> ( model, Cmd msg )
fromDouble ( model, reply ) =
    case reply of
        NoReply ->
            model & Cmd.none

        GoToLoginPage ->
            model & Route.goTo Route.Login
