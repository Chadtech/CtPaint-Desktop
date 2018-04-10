module Update exposing (update)

import Data.Drawing exposing (Drawing)
import Data.Entities as Entities
import Data.Taco as Taco exposing (Taco)
import Data.User as User
import Html.InitDrawing as InitDrawing
import Id
import Model exposing (Model)
import Msg exposing (Msg(..))
import Nav
import Page exposing (Page(..), Problem(..))
import Page.Contact as Contact
import Page.Error as Error
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Pricing as Pricing
import Page.Register as Register
import Page.ResetPassword as ResetPassword
import Page.RoadMap as RoadMap
import Page.Settings as Settings
import Page.Splash as Splash
import Page.Verify as Verify
import Ports exposing (JsMsg(..))
import Return2 as R2
import Return3 as R3
import Route exposing (Route(..))
import Tracking
    exposing
        ( Event
            ( DrawingDelete
            , DrawingsLoad
            , LoginSucceed
            , LogoutSucceed
            , MsgDecodeFail
            , PageMsgMismatch
            , RouteChange
            , RouteChangeFail
            )
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ taco, page } as model) =
    case msg of
        RouteChanged (Ok route) ->
            handleRoute route model
                |> R2.addCmd
                    (trackRouteChange taco model route)

        RouteChanged (Err url) ->
            { model
                | page = Error InvalidUrl
            }
                |> R2.withCmd
                    (Ports.track taco (RouteChangeFail url))

        LogInSucceeded user ->
            [ Route.goTo Route.Landing
            , Ports.track taco LoginSucceed
            ]
                |> Cmd.batch
                |> R2.withModel model
                |> R2.mapModel
                    (Model.setUser (User.LoggedIn user))

        LogOutSucceeded ->
            [ Route.goTo Route.Login
            , Ports.track taco LogoutSucceed
            ]
                |> Cmd.batch
                |> R2.withModel model
                |> R2.mapModel
                    (Model.setUser User.LoggedOut)

        MsgDecodeFailed err ->
            MsgDecodeFail err
                |> Ports.track taco
                |> R2.withModel model

        HomeMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Home subModel, User.LoggedIn _ ) ->
                    subModel
                        |> Home.update taco subMsg
                        |> R2.mapCmd HomeMsg
                        |> R2.mapModel (setPage Page.Home model)

                _ ->
                    model |> R2.withNoCmd

        InitDrawingMsg subMsg ->
            case page of
                Page.InitDrawing subModel ->
                    subModel
                        |> InitDrawing.update taco subMsg
                        |> R2.mapCmd InitDrawingMsg
                        |> R2.mapModel (setPage Page.InitDrawing model)

                _ ->
                    PageMsgMismatch
                        "init-drawing"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        PricingMsg subMsg ->
            case page of
                Page.Pricing ->
                    Pricing.update taco subMsg
                        |> Cmd.map PricingMsg
                        |> R2.withModel model

                _ ->
                    PageMsgMismatch
                        "pricing"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        RoadMapMsg subMsg ->
            case page of
                Page.RoadMap subModel ->
                    subModel
                        |> RoadMap.update taco subMsg
                        |> R2.mapCmd RoadMapMsg
                        |> R2.mapModel (setPage Page.RoadMap model)

                _ ->
                    PageMsgMismatch
                        "road-map"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        ContactMsg subMsg ->
            case page of
                Page.Contact subModel ->
                    subModel
                        |> Contact.update taco subMsg
                        |> R2.mapCmd ContactMsg
                        |> R2.mapModel (setPage Page.Contact model)

                _ ->
                    PageMsgMismatch
                        "contact"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        SplashMsg subMsg ->
            case page of
                Page.Splash ->
                    subMsg
                        |> Splash.update taco
                        |> Cmd.map SplashMsg
                        |> R2.withModel model

                _ ->
                    PageMsgMismatch
                        "splash"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        OfflineMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Offline, User.Offline ) ->
                    subMsg
                        |> Offline.update taco
                        |> Cmd.map OfflineMsg
                        |> R2.withModel model

                _ ->
                    PageMsgMismatch
                        "offline"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        RegisterMsg subMsg ->
            case page of
                Page.Register subModel ->
                    subModel
                        |> Register.update taco subMsg
                        |> R2.mapCmd RegisterMsg
                        |> R2.mapModel (setPage Page.Register model)

                _ ->
                    PageMsgMismatch
                        "register"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        LoginMsg subMsg ->
            case page of
                Page.Login subModel ->
                    subModel
                        |> Login.update taco subMsg
                        |> R2.mapCmd LoginMsg
                        |> R2.mapModel (setPage Page.Login model)

                _ ->
                    PageMsgMismatch
                        "login"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        ForgotPasswordMsg subMsg ->
            case page of
                Page.ForgotPassword subModel ->
                    subModel
                        |> ForgotPassword.update subMsg
                        |> R2.mapCmd ForgotPasswordMsg
                        |> R2.mapModel (setPage Page.ForgotPassword model)

                _ ->
                    PageMsgMismatch
                        "forgot-password"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        ResetPasswordMsg subMsg ->
            case page of
                Page.ResetPassword subModel ->
                    subModel
                        |> ResetPassword.update taco subMsg
                        |> R2.mapCmd ResetPasswordMsg
                        |> R2.mapModel (setPage Page.ResetPassword model)

                _ ->
                    PageMsgMismatch
                        "reset-password"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        LogoutMsg subMsg ->
            case page of
                Page.Logout subModel ->
                    subModel
                        |> Logout.update taco subMsg
                        |> R2.mapCmd LogoutMsg
                        |> R2.mapModel (setPage Page.Logout model)

                _ ->
                    PageMsgMismatch
                        "logout"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        VerifyMsg subMsg ->
            case page of
                Page.Verify subModel ->
                    subModel
                        |> Verify.update taco subMsg
                        |> R2.mapCmd VerifyMsg
                        |> R2.mapModel (setPage Page.Verify model)

                _ ->
                    PageMsgMismatch
                        "verify"
                        (Page.toString page)
                        |> Ports.track taco
                        |> R2.withModel model

        ErrorMsg subMsg ->
            case page of
                Page.Error _ ->
                    subMsg
                        |> Error.update taco
                        |> R2.withModel model

                _ ->
                    model |> R2.withNoCmd

        SettingsMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Settings subModel, User.LoggedIn user ) ->
                    subModel
                        |> Settings.update taco subMsg user
                        |> R3.mapCmd SettingsMsg
                        |> R3.incorp incorpSettings model

                _ ->
                    [ Route.goTo Route.Login
                    , PageMsgMismatch
                        "settings"
                        (Page.toString page)
                        |> Ports.track taco
                    ]
                        |> Cmd.batch
                        |> R2.withModel model

        NavMsg subMsg ->
            subMsg
                |> Nav.update taco
                |> Cmd.map NavMsg
                |> R2.withModel model

        DrawingsLoaded drawings ->
            { model
                | taco =
                    drawings
                        |> Entities.loadDrawings
                            taco.entities
                        |> Taco.setEntities taco
                , page =
                    case page of
                        Page.Home subModel ->
                            subModel
                                |> Home.drawingsLoaded
                                |> Page.Home

                        _ ->
                            page
            }
                |> R2.withCmd
                    (trackDrawingsLoad taco drawings)

        DrawingDeleted (Ok id) ->
            { model
                | taco =
                    taco.entities
                        |> Entities.deleteDrawing id
                        |> Taco.setEntities taco
                , page =
                    case ( Id.get id taco.entities.drawings, page ) of
                        ( Just { name }, Page.Home subModel ) ->
                            subModel
                                |> Home.drawingDeleted (Ok name)
                                |> Page.Home

                        _ ->
                            page
            }
                |> R2.withCmd
                    (Ports.track taco (DrawingDelete Nothing))

        DrawingDeleted (Err ( id, err )) ->
            { model
                | page =
                    case page of
                        Page.Home subModel ->
                            subModel
                                |> Home.drawingDeleted (Err id)
                                |> Page.Home

                        _ ->
                            page
            }
                |> R2.withCmd
                    (Ports.track taco (DrawingDelete (Just err)))


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute destination model =
    case destination of
        Route.Login ->
            { model
                | page = Page.Login Login.init
            }
                |> logout

        Route.ForgotPassword ->
            { model
                | page =
                    Page.ForgotPassword ForgotPassword.init
            }
                |> logout

        Route.ResetPassword email code ->
            { model
                | page =
                    ResetPassword.init email code
                        |> Page.ResetPassword
            }
                |> logout

        Route.Logout ->
            { model | page = Page.Logout Logout.init }
                |> logout

        Route.Register ->
            case model.page of
                Page.Register _ ->
                    model
                        |> R2.withNoCmd

                _ ->
                    { model
                        | page =
                            Page.Register Register.init
                    }
                        |> logout

        Route.Landing ->
            case model.taco.user of
                User.LoggedIn _ ->
                    Home.init
                        |> R2.mapCmd HomeMsg
                        |> R2.mapModel (setPage Page.Home model)

                User.Offline ->
                    { model | page = Page.Offline }
                        |> R2.withNoCmd

                _ ->
                    { model
                        | page = Page.Splash
                    }
                        |> R2.withNoCmd

        Route.InitDrawing ->
            { model
                | page =
                    Page.InitDrawing InitDrawing.init
            }
                |> R2.withNoCmd

        Route.About ->
            { model | page = Page.About }
                |> R2.withNoCmd

        Route.Documentation ->
            { model | page = Page.Documentation }
                |> R2.withNoCmd

        Route.Contact ->
            case model.page of
                Page.Contact _ ->
                    model
                        |> R2.withNoCmd

                _ ->
                    { model | page = Page.Contact Contact.init }
                        |> R2.withNoCmd

        Route.Pricing ->
            { model | page = Page.Pricing }
                |> R2.withNoCmd

        Route.RoadMap ->
            case model.page of
                Page.RoadMap _ ->
                    model
                        |> R2.withNoCmd

                _ ->
                    RoadMap.init model.taco.seed
                        |> Tuple.mapFirst
                            (setPage Page.RoadMap model)
                        |> Model.mixinSeed
                        |> R2.withNoCmd

        Route.Settings ->
            case model.taco.user of
                User.LoggedIn user ->
                    user
                        |> Settings.init
                        |> setPage Page.Settings model
                        |> R2.withNoCmd

                _ ->
                    Route.goTo Route.Login
                        |> R2.withModel model

        Route.Verify email code ->
            Verify.init email
                |> setPage Page.Verify model
                |> logout
                |> R2.addCmd (Ports.send (VerifyEmail email code))


logout : Model -> ( Model, Cmd Msg )
logout model =
    case model.taco.user of
        User.LoggedIn user ->
            { model
                | taco =
                    Taco.setUser User.LoggedOut model.taco
            }
                |> R2.withCmd (Ports.send Ports.Logout)

        _ ->
            model
                |> R2.withNoCmd



-- HELPERS --


setPage : (subModel -> Page) -> Model -> subModel -> Model
setPage pageCtor model subModel =
    { model | page = pageCtor subModel }


incorpSettings : Settings.Model -> Maybe Settings.Reply -> Model -> ( Model, Cmd Msg )
incorpSettings subModel maybeReply model =
    case maybeReply of
        Nothing ->
            { model | page = Page.Settings subModel }
                |> R2.withNoCmd

        Just (Settings.SetUser user) ->
            model
                |> Model.setUser (User.LoggedIn user)
                |> R2.withNoCmd


trackRouteChange : Taco -> Model -> Route -> Cmd Msg
trackRouteChange taco model route =
    RouteChange
        (Page.toString model.page)
        (toString route)
        |> Ports.track taco


trackDrawingsLoad : Taco -> List Drawing -> Cmd Msg
trackDrawingsLoad taco drawings =
    drawings
        |> List.length
        |> DrawingsLoad
        |> Ports.track taco
