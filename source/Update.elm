module Update exposing (update)

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
    case msg of
        SetRoute (Just route) ->
            handleRoute route model

        SetRoute Nothing ->
            { model
                | page = Error InvalidUrl
            }
                & Cmd.none

        LoggedIn ->
            model & Route.goTo Route.Home

        LoggedOut ->
            { model
                | user = Nothing
            }
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
            model & Route.goTo route


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute destination model =
    case destination of
        Route.Login ->
            { model
                | user = Nothing
                , page = Page.Login Login.init
            }
                & Ports.send Ports.Logout

        Route.Logout ->
            { model
                | user = Nothing
                , page = Page.Logout Logout.init
            }
                & Ports.send Ports.Logout

        Route.Register ->
            { model
                | user = Nothing
                , page = Page.Register Register.init
            }
                & Ports.send Ports.Logout

        Route.Home ->
            case model.user of
                Just user ->
                    { model
                        | page = Page.Home {}
                    }
                        & Cmd.none

                Nothing ->
                    model & Route.goTo Route.Login

        Route.Settings ->
            case model.user of
                Just user ->
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
            { model
                | user = Nothing
                , page =
                    Page.Verify (Verify.init email)
            }
                & Cmd.batch
                    [ Ports.send Ports.Logout
                    , Ports.send (VerifyEmail email code)
                    ]


incorporateHome : ( Home.Model, Home.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateHome ( homeModel, reply ) model =
    case reply of
        Home.NoReply ->
            { model
                | page = Page.Home homeModel
            }
                & Cmd.none
