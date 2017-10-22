module Page exposing (..)

import Page.Home as Home
import Page.Login as Login
import Page.Register as Register


type Page
    = Home Home.Model
    | Error Problem
    | Settings
    | Register Register.Model
    | Login Login.Model
    | Logout
    | Verify


type Problem
    = InvalidUrl
    | NoPageLoaded


toUrl : Page -> String
toUrl page =
    case page of
        Home _ ->
            "home"

        Error _ ->
            "error"

        Settings ->
            "settings"

        Register _ ->
            "register"

        Login _ ->
            "login"

        Logout ->
            "logout"

        Verify ->
            "verify"
