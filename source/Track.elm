module Track exposing (track)

import Data.Tracking as Tracking
import Data.User as User
import Html.InitDrawing as InitDrawing
import Json.Encode as Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Nav
import Page exposing (Page(..), Problem(..))
import Page.Contact as Contact
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


{-|

    Much like the update function,
    however its meant to map the incoming
    Msgs to a tracking event.

-}
track : Msg -> Model -> Maybe Tracking.Event
track msg { page, taco } =
    case msg of
        RouteChanged (Ok route) ->
            [ page
                |> Page.toString
                |> Encode.string
                |> def "from-page"
            , route
                |> toString
                |> Encode.string
                |> def "to-route"
            ]
                |> def "route change"
                |> Just

        RouteChanged (Err url) ->
            url
                |> Encode.string
                |> def "url"
                |> List.singleton
                |> def "route change fail"
                |> Just

        LogInSucceeded _ ->
            Tracking.noProps "login succeed"

        LogOutSucceeded ->
            Tracking.noProps "logout succeed"

        MsgDecodeFailed err type_ ->
            [ def "error" <| Encode.string err
            , def "type" <| Encode.string type_
            ]
                |> def "msg decode fail"
                |> Just

        HomeMsg subMsg ->
            let
                pageStr =
                    "home"
            in
            case ( page, taco.user ) of
                ( Page.Home subModel, User.LoggedIn _ ) ->
                    subModel
                        |> Home.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        InitDrawingMsg subMsg ->
            let
                pageStr =
                    "init-drawing"
            in
            case page of
                Page.InitDrawing subModel ->
                    subModel
                        |> InitDrawing.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        AllowanceExceededMsg subMsg ->
            let
                pageStr =
                    "allowance-exceeded"
            in
            case page of
                Page.AllowanceExceeded ->
                    AllowanceExceeded.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        PricingMsg subMsg ->
            let
                pageStr =
                    "pricing"
            in
            case page of
                Page.Pricing ->
                    Pricing.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        RoadMapMsg subMsg ->
            let
                pageStr =
                    "road-map"
            in
            case page of
                Page.RoadMap subModel ->
                    RoadMap.track subMsg subModel
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        ContactMsg subMsg ->
            let
                pageStr =
                    "contact"
            in
            case page of
                Page.Contact subModel ->
                    Contact.track subMsg subModel
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        SplashMsg subMsg ->
            let
                pageStr =
                    "splash"
            in
            case page of
                Page.Splash ->
                    Splash.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        SettingsMsg subMsg ->
            let
                pageStr =
                    "settings"
            in
            case page of
                Page.Settings subModel ->
                    Settings.track subMsg subModel
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        OfflineMsg subMsg ->
            let
                pageStr =
                    "offline"
            in
            case ( page, taco.user ) of
                ( Page.Offline, User.Offline ) ->
                    Offline.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        RegisterMsg subMsg ->
            let
                pageStr =
                    "register"
            in
            case page of
                Page.Register _ ->
                    Register.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        LoginMsg subMsg ->
            let
                pageStr =
                    "login"
            in
            case page of
                Page.Login _ ->
                    Login.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        ForgotPasswordMsg subMsg ->
            let
                pageStr =
                    "forgot-password"
            in
            case page of
                Page.ForgotPassword _ ->
                    ForgotPassword.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        ResetPasswordMsg subMsg ->
            let
                pageStr =
                    "reset-password"
            in
            case page of
                Page.ResetPassword _ ->
                    ResetPassword.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        LogoutMsg subMsg ->
            let
                pageStr =
                    "logout"
            in
            case page of
                Page.Logout _ ->
                    Logout.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        VerifyMsg subMsg ->
            let
                pageStr =
                    "verify"
            in
            case page of
                Page.Verify subModel ->
                    Verify.track subMsg subModel
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        ErrorMsg subMsg ->
            let
                pageStr =
                    "error"
            in
            case page of
                Page.Error _ ->
                    Error.track subMsg
                        |> Tracking.namespace pageStr

                _ ->
                    pageMsgMismatch pageStr page

        NavMsg subMsg ->
            Nav.track subMsg
                |> Tracking.namespace "nav"

        DrawingsLoaded drawings ->
            drawings
                |> List.length
                |> Encode.int
                |> def "number-loaded"
                |> List.singleton
                |> def "drawings load"
                |> Just

        DrawingDeleted (Ok _) ->
            Tracking.response Nothing
                |> Tracking.namespace "drawing delete"

        DrawingDeleted (Err ( _, err )) ->
            err
                |> Just
                |> Tracking.response
                |> Tracking.namespace "drawing delete"


pageMsgMismatch : String -> Page -> Maybe Tracking.Event
pageMsgMismatch msgType page =
    [ msgType
        |> Encode.string
        |> def "msg-type"
    , page
        |> Page.toString
        |> Encode.string
        |> def "page"
    ]
        |> def "page msg mismatch"
        |> Just
