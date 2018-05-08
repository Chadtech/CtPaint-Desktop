module Page
    exposing
        ( Page(..)
        , Problem(..)
        , toString
        )

import Html.InitDrawing as InitDrawing
import Page.Contact as Contact
import Page.Documentation as Documentation
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.ResetPassword as ResetPassword
import Page.RoadMap as RoadMap
import Page.Settings as Settings
import Page.Verify as Verify


-- TYPES --


type Page
    = Home Home.Model
    | InitDrawing InitDrawing.Model
    | About
    | Documentation Documentation.Model
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
    | Error Problem
    | Blank


type Problem
    = InvalidUrl



-- HELPERS --


{-| Pages correspond to specific strings in different
functionality of this application, and to make sure
the pages are mapped to the right strings, this function
is used. If I just wrote "home" where I needed home I
might get a typo. But by using the union type the compiler
will catch my mistakes.
-}
toString : Page -> String
toString page =
    case page of
        Home _ ->
            "home"

        InitDrawing _ ->
            "init-drawing"

        About ->
            "about"

        Documentation _ ->
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

        Blank ->
            "blank"

        Error problem ->
            "error : " ++ Basics.toString problem
