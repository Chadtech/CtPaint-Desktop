module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation
import Page exposing (Page(..), Problem(..))
import Page.Home as Home
import Page.Login as Login
import Page.Register as Register
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Route exposing (Route(..))
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRoute (Just route) ->
            handleRoute route model

        SetRoute Nothing ->
            { model
                | page = Error InvalidUrl
            }
                & Cmd.none

        LoggedIn ->
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

        VerifyMsg subMsg ->
            case model.page of
                Page.Verify subModel ->
                    let
                        ( newSubModel, cmd ) =
                            Verify.update subMsg subModel
                    in
                    { model
                        | page = Page.Verify newSubModel
                    }
                        & Cmd.map VerifyMsg cmd

                _ ->
                    model & Cmd.none

        Navigate route ->
            model & goTo route


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute destination model =
    case destination of
        Route.Login ->
            let
                page =
                    Page.Login Login.init

                cmd =
                    [ Ports.send EndSession ]
                        |> Cmd.batch
            in
            { model
                | session = Nothing
                , page = page
            }
                & cmd

        Route.Logout ->
            { model
                | session = Nothing
                , page = Page.Logout
            }
                & Ports.send EndSession

        Route.Register ->
            { model
                | session = Nothing
                , page = Page.Register Register.init
            }
                & Ports.send EndSession

        Route.Home ->
            case model.session of
                Just session ->
                    { model
                        | page = Page.Home {}
                    }
                        & Cmd.none

                Nothing ->
                    model & goTo Route.Login

        Route.Settings ->
            case model.session of
                Just session ->
                    { model
                        | page = Page.Settings
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | page = Page.Login Login.init
                    }
                        & Cmd.none

        Route.PaintApp ->
            model & Ports.send OpenPaintApp

        Route.Verify email code ->
            let
                cmd =
                    [ Ports.send EndSession
                    , Ports.send (VerifyEmail email code)
                    ]
                        |> Cmd.batch
            in
            { model
                | session = Nothing
                , page =
                    Page.Verify (Verify.init email)
            }
                & cmd


goTo : Route -> Cmd Msg
goTo =
    Route.toUrl >> Debug.log "go to" >> Navigation.newUrl


incorporateHome : ( Home.Model, Home.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateHome ( homeModel, reply ) model =
    case reply of
        Home.NoReply ->
            { model
                | page = Page.Home homeModel
            }
                & Cmd.none
