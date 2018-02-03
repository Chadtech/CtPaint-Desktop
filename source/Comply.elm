module Comply
    exposing
        ( fromDouble
        , fromTriple
        , noReply
        )

import Model exposing (Model)
import Msg exposing (Msg(..))
import Reply exposing (Reply(..))
import Tuple.Infix exposing ((&))
import Util


noReply : ( model, Cmd msg ) -> ( model, Cmd msg, Reply )
noReply ( model, cmd ) =
    ( model, cmd, NoReply )


fromTriple : ( Model, Cmd Msg, Reply ) -> ( Model, Cmd Msg )
fromTriple ( model, cmd, reply ) =
    model
        & reply
        |> fromDouble
        |> Util.addCmd cmd


fromDouble : ( Model, Reply ) -> ( Model, Cmd Msg )
fromDouble ( model, reply ) =
    case reply of
        NoReply ->
            model & Cmd.none
