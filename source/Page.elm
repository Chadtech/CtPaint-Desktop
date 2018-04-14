module Page
    exposing
        ( HoldUp(..)
        , Page(..)
        , Problem(..)
        , toString
        )

import Html.InitDrawing as InitDrawing
import Page.Contact as Contact
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.ResetPassword as ResetPassword
import Page.RoadMap as RoadMap
import Page.Settings as Settings
import Page.Verify as Verify


type Page
    = Home Home.Model
    | InitDrawing InitDrawing.Model
    | About
    | Documentation
    | Contact Contact.Model
    | Pricing
    | RoadMap RoadMap.Model
    | Settings Settings.Model
    | Register Register.Model
    | Login Login.Model
    | ForgotPassword ForgotPassword.Model
    | ResetPassword ResetPassword.Model
    | Logout Logout.Model
    | Verify Verify.Model
    | AllowanceExceeded
    | Splash
    | Offline
    | Loading HoldUp
    | Error Problem
    | Blank


type HoldUp
    = UserAttributes


type Problem
    = InvalidUrl



-- HELPERS --


toString : Page -> String
toString page =
    case page of
        Home _ ->
            "home"

        InitDrawing _ ->
            "init-drawing"

        About ->
            "about"

        Documentation ->
            "documentation"

        Contact _ ->
            "contact"

        Pricing ->
            "pricing"

        RoadMap _ ->
            "road-map"

        Settings _ ->
            "settings"

        Register _ ->
            "register"

        Login _ ->
            "login"

        ForgotPassword _ ->
            "forgot-password"

        ResetPassword _ ->
            "reset-password"

        Logout _ ->
            "logout"

        Verify _ ->
            "verify"

        AllowanceExceeded ->
            "allowance-exceeded"

        Splash ->
            "splash"

        Offline ->
            "offline"

        Loading holdUp ->
            "loading : " ++ Basics.toString holdUp

        Blank ->
            "blank"

        Error problem ->
            "error : " ++ Basics.toString problem
