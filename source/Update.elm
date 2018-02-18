module Update exposing (update)

import Comply
import Data.Taco as Taco
import Data.User as User
import Model
    exposing
        ( Model
        , return
        , return2
        , return3
        )
import Msg exposing (Msg(..))
import Nav
import Page exposing (Page(..), Problem(..))
import Page.Contact as Contact
import Page.Error as Error
import Page.Home as Home
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Pricing as Pricing
import Page.Register as Register
import Page.RoadMap as RoadMap
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
                & Route.goTo Route.Landing

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
                        |> return3 Page.Home model
                        |> Tuple3.mapSecond (Cmd.map HomeMsg)
                        |> Comply.fromTriple

                _ ->
                    model & Cmd.none

        InitDrawingMsg subMsg ->
            case model.page of
                Page.InitDrawing subModel ->
                    subModel
                        |> InitDrawing.update subMsg
                        |> return2 Page.InitDrawing model
                        |> Tuple.mapSecond (Cmd.map InitDrawingMsg)

                _ ->
                    model & Cmd.none

        PricingMsg subMsg ->
            case model.page of
                Page.Pricing ->
                    model & Cmd.map PricingMsg (Pricing.update subMsg)

                _ ->
                    model & Cmd.none

        RoadMapMsg subMsg ->
            case model.page of
                Page.RoadMap subModel ->
                    subModel
                        |> RoadMap.update model.taco subMsg
                        |> return2 Page.RoadMap model
                        |> Tuple.mapSecond (Cmd.map RoadMapMsg)

                _ ->
                    model & Cmd.none

        ContactMsg subMsg ->
            case model.page of
                Page.Contact subModel ->
                    subModel
                        |> Contact.update subMsg
                        |> return2 Page.Contact model
                        |> Tuple.mapSecond (Cmd.map ContactMsg)

                _ ->
                    model & Cmd.none

        SplashMsg subMsg ->
            model & Cmd.map SplashMsg (Splash.update subMsg)

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
                        |> return2 Page.Verify model
                        |> Tuple.mapSecond (Cmd.map VerifyMsg)

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
                        |> return3 Page.Settings model
                        |> Tuple3.mapSecond (Cmd.map SettingsMsg)
                        |> Comply.fromTriple

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
            case model.page of
                Page.Register _ ->
                    model & Cmd.none

                _ ->
                    { model
                        | page =
                            Page.Register Register.init
                    }
                        |> logout

        Route.Landing ->
            case model.taco.user of
                User.LoggedIn user ->
                    Home.init user
                        |> Tuple.mapFirst (return Page.Home model)
                        |> Tuple.mapSecond (Cmd.map HomeMsg)

                User.Offline ->
                    { model | page = Page.Offline }
                        & Cmd.none

                _ ->
                    { model
                        | page = Page.Splash
                    }
                        & Cmd.none

        Route.InitDrawing ->
            { model
                | page =
                    Page.InitDrawing InitDrawing.init
            }
                & Cmd.none

        Route.About ->
            { model | page = Page.About }
                & Cmd.none

        Route.Documentation ->
            { model | page = Page.Documentation }
                & Cmd.none

        Route.Contact ->
            case model.page of
                Page.Contact _ ->
                    model & Cmd.none

                _ ->
                    { model | page = Page.Contact Contact.init }
                        & Cmd.none

        Route.Pricing ->
            { model | page = Page.Pricing }
                & Cmd.none

        Route.RoadMap ->
            case model.page of
                Page.RoadMap _ ->
                    model & Cmd.none

                _ ->
                    RoadMap.init model.taco.seed
                        |> return2 Page.RoadMap model
                        |> Model.mixinSeed
                        & Cmd.none

        Route.Settings ->
            case model.taco.user of
                User.LoggedIn user ->
                    Settings.init
                        |> return Page.Settings model
                        & Cmd.none

                _ ->
                    model & Route.goTo Route.Login

        Route.Verify email code ->
            Verify.init email
                |> return Page.Verify model
                |> logout
                |> Util.addCmd (Ports.send (VerifyEmail email code))


logout : Model -> ( Model, Cmd Msg )
logout model =
    { model
        | taco =
            Taco.setUser User.LoggedOut model.taco
    }
        & Ports.send Ports.Logout
