module Update exposing (update)

import Data.User as User
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page exposing (Page(..), Problem(..))
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Route exposing (Route(..))
import Tuple.Infix exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "MSG" msg of
        SetRoute (Just route) ->
            handleRoute route model

        SetRoute Nothing ->
            { model
                | page = Error InvalidUrl
            }
                & Cmd.none

        LogInSucceeded user ->
            { model | user = User.LoggedIn user }
                & Route.goTo Route.Home

        LogOutSucceeded ->
            { model | user = User.NoSession }
                & Route.goTo Route.Login

        LogOutFailed err ->
            model & Cmd.none

        InvalidJsMsg err ->
            model & Cmd.none

        HomeMsg subMsg ->
            case model.page of
                Page.Home subModel ->
                    incorporateHome
                        (Home.update subMsg subModel)
                        model

                _ ->
                    model & Cmd.none

        RegisterMsg subMsg ->
            case model.page of
                Page.Register subModel ->
                    let
                        ( newSubModel, cmd ) =
                            Register.update subMsg subModel
                    in
                    { model
                        | page =
                            Page.Register newSubModel
                    }
                        & Cmd.map RegisterMsg cmd

                _ ->
                    model & Cmd.none

        LoginMsg subMsg ->
            case model.page of
                Page.Login subModel ->
                    let
                        ( newSubModel, cmd ) =
                            Login.update subMsg subModel
                    in
                    { model
                        | page =
                            Page.Login newSubModel
                    }
                        & Cmd.map LoginMsg cmd

                _ ->
                    model & Cmd.none

        LogoutMsg subMsg ->
            case model.page of
                Page.Logout subModel ->
                    let
                        ( newSubModel, cmd ) =
                            Logout.update subMsg subModel
                    in
                    { model
                        | page =
                            Page.Logout newSubModel
                    }
                        & Cmd.map LogoutMsg cmd

                _ ->
                    model & Cmd.none

        VerifyMsg subMsg ->
            case model.page of
                Page.Verify subModel ->
                    let
                        ( newSubModel, reply ) =
                            Verify.update subMsg subModel
                    in
                    case reply of
                        Verify.NoReply ->
                            { model
                                | page = Page.Verify newSubModel
                            }
                                & Cmd.none

                        Verify.GoToLogin ->
                            model & Route.goTo Route.Login

                _ ->
                    model & Cmd.none

        Navigate route ->
            model & Route.goTo route


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute destination model =
    case destination of
        Route.Login ->
            { model
                | page = Page.Login Login.init
            }
                |> logout

        Route.Logout ->
            { model | page = Page.Logout Logout.init }
                |> logout

        Route.Register ->
            { model | page = Page.Register Register.init }
                |> logout

        Route.Home ->
            case model.user of
                User.LoggedIn user ->
                    { model
                        | page = Page.Home {}
                    }
                        & Cmd.none

                _ ->
                    model & Route.goTo Route.Login

        Route.Settings ->
            case model.user of
                User.LoggedIn user ->
                    { model
                        | page = Page.Settings
                    }
                        & Cmd.none

                _ ->
                    model & Route.goTo Route.Login

        Route.PaintApp ->
            model & Ports.send OpenPaintApp

        Route.Verify email code ->
            { model
                | page = Page.Verify (Verify.init email)
            }
                |> logout
                |> mixinCmd (Ports.send (VerifyEmail email code))


logout : Model -> ( Model, Cmd Msg )
logout model =
    { model
        | user = User.NoSession
    }
        & Ports.send Ports.Logout


mixinCmd : Cmd Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
mixinCmd newCmd ( model, cmd ) =
    model & Cmd.batch [ newCmd, cmd ]


incorporateHome : ( Home.Model, Home.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateHome ( homeModel, reply ) model =
    case reply of
        Home.NoReply ->
            { model
                | page = Page.Home homeModel
            }
                & Cmd.none
