module Update exposing (update)

import Comply
import Data.Taco as Taco
import Data.User as User
import Html.Nav as Nav
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page exposing (Page(..), Problem(..))
import Page.Error as Error
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Register as Register
import Page.Settings as Settings
import Page.Splash as Splash
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Route exposing (Route(..))
import Tuple.Infix exposing ((&))
import Tuple3
import Util


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged (Just route) ->
            handleRoute route model

        RouteChanged Nothing ->
            { model
                | page = Error InvalidUrl
            }
                & Cmd.none

        LogInSucceeded user ->
            model
                |> Model.setUser (User.LoggedIn user)
                & Route.goTo Route.Home

        LogOutSucceeded ->
            model
                |> Model.setUser User.LoggedOut
                & Route.goTo Route.Login

        LogOutFailed err ->
            model & Cmd.none

        MsgDecodeFailed err ->
            model & Cmd.none

        HomeMsg subMsg ->
            case ( model.page, model.taco.user ) of
                ( Page.Home subModel, User.LoggedIn user ) ->
                    subModel
                        |> Home.update subMsg
                        |> Tuple3.mapFirst (integrateHome model)
                        |> Tuple3.mapSecond (Cmd.map HomeMsg)
                        |> Comply.fromTriple

                _ ->
                    model & Cmd.none

        SplashMsg subMsg ->
            case ( model.page, model.taco.user ) of
                ( Page.Splash, User.LoggedOut ) ->
                    model & Cmd.map SplashMsg (Splash.update subMsg)

                _ ->
                    model & Cmd.none

        OfflineMsg subMsg ->
            case ( model.page, model.taco.user ) of
                ( Page.Offline, User.Offline ) ->
                    model & Cmd.map OfflineMsg (Offline.update subMsg)

                _ ->
                    model & Cmd.none

        RegisterMsg subMsg ->
            case model.page of
                Page.Register subModel ->
                    let
                        ( newSubModel, cmd ) =
                            Register.update model.taco subMsg subModel
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
                    subModel
                        |> Verify.update subMsg
                        |> Tuple.mapFirst (integrateVerify model)
                        |> Comply.fromDouble

                _ ->
                    model & Cmd.none

        ErrorMsg subMsg ->
            case model.page of
                Page.Error _ ->
                    model & Error.update subMsg

                _ ->
                    model & Cmd.none

        SettingsMsg subMsg ->
            case ( model.page, model.taco.user ) of
                ( Page.Settings subModel, User.LoggedIn user ) ->
                    subModel
                        |> Settings.update subMsg user
                        |> Tuple.mapFirst (integrateSettings model)
                        |> Tuple.mapSecond (Cmd.map SettingsMsg)

                _ ->
                    model & Route.goTo Route.Login

        NavMsg subMsg ->
            model & Cmd.map NavMsg (Nav.update subMsg)


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
            case model.taco.user of
                User.LoggedIn user ->
                    let
                        ( subModel, cmd ) =
                            Home.init user
                    in
                    { model
                        | page = Page.Home subModel
                    }
                        & Cmd.map HomeMsg cmd

                _ ->
                    model & Route.goTo Route.Login

        Route.Settings ->
            case model.taco.user of
                User.LoggedIn user ->
                    { model
                        | page = Page.Settings Settings.init
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
                |> Util.addCmd (Ports.send (VerifyEmail email code))


integrateSettings : Model -> Settings.Model -> Model
integrateSettings model settingsModel =
    { model | page = Page.Settings settingsModel }


integrateHome : Model -> Home.Model -> Model
integrateHome model homeModel =
    { model | page = Page.Home homeModel }


integrateVerify : Model -> Verify.Model -> Model
integrateVerify model verifyModel =
    { model | page = Page.Verify verifyModel }


logout : Model -> ( Model, Cmd Msg )
logout model =
    { model
        | taco =
            Taco.setUser User.LoggedOut model.taco
    }
        & Ports.send Ports.Logout
