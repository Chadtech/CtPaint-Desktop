module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import Page exposing (Page(..), Problem(..))
import Page.Home as Home
import Ports exposing (JsMsg(..))
import Route exposing (Route(..))
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetRoute (Just route) ->
            handleRoute route model

        SetRoute Nothing ->
            { model
                | page = Error InvalidUrl
            }
                & Cmd.none

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

        Noop ->
            model & Cmd.none


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute destination model =
    case destination of
        Route.Login ->
            { model
                | session = Nothing
                , page = Page.Login
            }
                & Ports.send EndSession

        Route.Logout ->
            { model
                | session = Nothing
                , page = Page.Logout
            }
                & Ports.send EndSession

        Route.Register ->
            { model
                | session = Nothing
                , page = Page.Register
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
                    { model
                        | page = Page.Login
                    }
                        & Cmd.none

        Route.Settings ->
            case model.session of
                Just session ->
                    { model
                        | page = Page.Settings
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | page = Page.Login
                    }
                        & Cmd.none

        Route.PaintApp ->
            model & Ports.send OpenPaintApp


incorporateHome : ( Home.Model, Home.Reply ) -> Model -> ( Model, Cmd Msg )
incorporateHome ( homeModel, reply ) model =
    case reply of
        Home.NoReply ->
            { model
                | page = Page.Home homeModel
            }
                & Cmd.none
