module Comply
    exposing
        ( fromDouble
        , fromTriple
        )

import Data.User as User exposing (User)
import Model exposing (Model)
import Reply exposing (Reply(..))
import Tuple.Infix exposing ((&))
import Util


fromTriple : ( Model, Cmd msg, Reply ) -> ( Model, Cmd msg )
fromTriple ( model, cmd, reply ) =
    model
        & reply
        |> fromDouble
        |> Util.addCmd cmd


fromDouble : ( Model, Reply ) -> ( Model, Cmd msg )
fromDouble ( model, reply ) =
    case reply of
        NoReply ->
            model & Cmd.none

        SetUser user ->
            Model.setUser (User.LoggedIn user) model
                & Cmd.none
