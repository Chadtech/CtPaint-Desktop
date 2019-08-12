module Update exposing (update)

import Data.Entities as Entities
import Data.Taco as Taco
import Data.User as User
import Html.InitDrawing as InitDrawing
import Model exposing (Model)
import Msg exposing (Msg(..))
import Nav
import Page exposing (Page(..), Problem(..))
import Page.Contact as Contact
import Page.Documentation as Documentation
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
import Route exposing (Route(..))
import Util.Cmd as CmdUtil


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ taco, page } as model) =
    case msg of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            { model
                | page = Error InvalidUrl
            }
                |> CmdUtil.withNoCmd

        LogInSucceeded user ->
            Route.goTo Route.Landing
                |> CmdUtil.withModel model
                |> CmdUtil.mapModel
                    (Model.setUser (User.LoggedIn user))

        LogOutSucceeded ->
            Route.goTo Route.Login
                |> CmdUtil.withModel model
                |> CmdUtil.mapModel
                    (Model.setUser User.LoggedOut)

        MsgDecodeFailed _ _ ->
            model
                |> CmdUtil.withNoCmd

        HomeMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Home subModel, User.LoggedIn _ ) ->
                    subModel
                        |> Home.update subMsg
                        |> CmdUtil.mapCmd HomeMsg
                        |> CmdUtil.mapModel (setPage Page.Home model)

                _ ->
                    model |> CmdUtil.withNoCmd

        InitDrawingMsg subMsg ->
            case page of
                Page.InitDrawing subModel ->
                    subModel
                        |> InitDrawing.update subMsg
                        |> CmdUtil.mapCmd InitDrawingMsg
                        |> CmdUtil.mapModel (setPage Page.InitDrawing model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        AllowanceExceededMsg subMsg ->
            case page of
                Page.AllowanceExceeded ->
                    AllowanceExceeded.update subMsg
                        |> Cmd.map AllowanceExceededMsg
                        |> CmdUtil.withModel model

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        PricingMsg subMsg ->
            case page of
                Page.Pricing ->
                    Pricing.update subMsg
                        |> Cmd.map PricingMsg
                        |> CmdUtil.withModel model

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        RoadMapMsg subMsg ->
            case page of
                Page.RoadMap subModel ->
                    subModel
                        |> RoadMap.update subMsg
                        |> setPage Page.RoadMap model
                        |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ContactMsg subMsg ->
            case page of
                Page.Contact subModel ->
                    subModel
                        |> Contact.update subMsg
                        |> setPage Page.Contact model
                        |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        SplashMsg subMsg ->
            case page of
                Page.Splash ->
                    subMsg
                        |> Splash.update
                        |> Cmd.map SplashMsg
                        |> CmdUtil.withModel model

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        OfflineMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Offline, User.Offline ) ->
                    subMsg
                        |> Offline.update
                        |> Cmd.map OfflineMsg
                        |> CmdUtil.withModel model

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        RegisterMsg subMsg ->
            case page of
                Page.Register subModel ->
                    subModel
                        |> Register.update taco subMsg
                        |> CmdUtil.mapCmd RegisterMsg
                        |> CmdUtil.mapModel (setPage Page.Register model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        LoginMsg subMsg ->
            case page of
                Page.Login subModel ->
                    subModel
                        |> Login.update subMsg
                        |> CmdUtil.mapCmd LoginMsg
                        |> CmdUtil.mapModel (setPage Page.Login model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ForgotPasswordMsg subMsg ->
            case page of
                Page.ForgotPassword subModel ->
                    subModel
                        |> ForgotPassword.update subMsg
                        |> CmdUtil.mapCmd ForgotPasswordMsg
                        |> CmdUtil.mapModel (setPage Page.ForgotPassword model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ResetPasswordMsg subMsg ->
            case page of
                Page.ResetPassword subModel ->
                    subModel
                        |> ResetPassword.update subMsg
                        |> CmdUtil.mapCmd ResetPasswordMsg
                        |> CmdUtil.mapModel (setPage Page.ResetPassword model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        LogoutMsg subMsg ->
            case page of
                Page.Logout _ ->
                    subMsg
                        |> Logout.update
                        |> setPage Page.Logout model
                        |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        VerifyMsg subMsg ->
            case page of
                Page.Verify subModel ->
                    subModel
                        |> Verify.update subMsg
                        |> CmdUtil.mapCmd VerifyMsg
                        |> CmdUtil.mapModel (setPage Page.Verify model)

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ErrorMsg subMsg ->
            case page of
                Page.Error _ ->
                    subMsg
                        |> Error.update
                        |> CmdUtil.withModel model

                _ ->
                    model |> CmdUtil.withNoCmd

        SettingsMsg subMsg ->
            case ( page, taco.user ) of
                ( Page.Settings subModel, User.LoggedIn user ) ->
                    subModel
                        |> Settings.update subMsg user
                        |> R3.mapCmd SettingsMsg
                        |> R3.incorp incorpSettings model

                _ ->
                    Route.goTo Route.Login
                        |> CmdUtil.withModel model

        NavMsg subMsg ->
            subMsg
                |> Nav.update
                |> Cmd.map NavMsg
                |> CmdUtil.withModel model

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
                |> CmdUtil.withNoCmd

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
                |> CmdUtil.withNoCmd

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
                |> CmdUtil.withNoCmd



-- HELPERS --


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

        Route.ResetPassword ->
            { model
                | page =
                    ResetPassword.init
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
                        |> CmdUtil.withNoCmd

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
                        |> CmdUtil.mapCmd HomeMsg
                        |> CmdUtil.mapModel (setPage Page.Home model)

                User.Offline ->
                    { model | page = Page.Offline }
                        |> CmdUtil.withNoCmd

                _ ->
                    { model
                        | page = Page.Splash
                    }
                        |> CmdUtil.withNoCmd

        Route.InitDrawing ->
            { model
                | page =
                    Page.InitDrawing InitDrawing.init
            }
                |> CmdUtil.withNoCmd

        Route.About ->
            { model | page = Page.About }
                |> CmdUtil.withNoCmd

        Route.Documentation ->
            case model.page of
                Page.Documentation _ ->
                    model
                        |> CmdUtil.withNoCmd

                _ ->
                    Documentation.init model.taco.seed
                        |> Tuple.mapFirst
                            (setPage Page.Documentation model)
                        |> Model.mixinSeed
                        |> CmdUtil.withNoCmd

        Route.Contact ->
            case model.page of
                Page.Contact _ ->
                    model
                        |> CmdUtil.withNoCmd

                _ ->
                    { model | page = Page.Contact Contact.init }
                        |> CmdUtil.withNoCmd

        Route.Pricing ->
            { model | page = Page.Pricing }
                |> CmdUtil.withNoCmd

        Route.RoadMap ->
            case model.page of
                Page.RoadMap _ ->
                    model
                        |> CmdUtil.withNoCmd

                _ ->
                    RoadMap.init model.taco.seed
                        |> Tuple.mapFirst
                            (setPage Page.RoadMap model)
                        |> Model.mixinSeed
                        |> CmdUtil.withNoCmd

        Route.Settings ->
            case model.taco.user of
                User.LoggedIn user ->
                    user
                        |> Settings.init
                        |> setPage Page.Settings model
                        |> CmdUtil.withNoCmd

                _ ->
                    Route.goTo Route.Login
                        |> CmdUtil.withModel model

        Route.Verify ->
            Verify.init
                |> setPage Page.Verify model
                |> logout

        Route.AllowanceExceeded ->
            case model.taco.user of
                User.LoggedIn _ ->
                    Home.init
                        |> CmdUtil.mapCmd HomeMsg
                        |> CmdUtil.mapModel (setPage Page.Home model)

                _ ->
                    { model | page = Page.AllowanceExceeded }
                        |> CmdUtil.withNoCmd


logout : Model -> ( Model, Cmd Msg )
logout model =
    case model.taco.user of
        User.LoggedIn user ->
            { model
                | taco =
                    Taco.setUser User.LoggedOut model.taco
            }
                |> CmdUtil.withCmd (Ports.send Ports.Logout)

        _ ->
            model
                |> CmdUtil.withNoCmd


setPage : (subModel -> Page) -> Model -> subModel -> Model
setPage pageCtor model subModel =
    { model | page = pageCtor subModel }


incorpSettings : Settings.Model -> Maybe Settings.Reply -> Model -> ( Model, Cmd Msg )
incorpSettings subModel maybeReply model =
    case maybeReply of
        Nothing ->
            { model | page = Page.Settings subModel }
                |> CmdUtil.withNoCmd

        Just (Settings.SetUser user) ->
            model
                |> Model.setUser (User.LoggedIn user)
                |> CmdUtil.withNoCmd
