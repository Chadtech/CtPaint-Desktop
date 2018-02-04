module Page exposing (..)

import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Offline as Offline
import Page.Register as Register
import Page.Splash as Splash
import Page.Verify as Verify


type Page
    = Home Home.Model
    | Error Problem
    | Settings
    | Register Register.Model
    | Login Login.Model
    | Logout Logout.Model
    | Verify Verify.Model
    | Splash
    | Offline
    | Loading HoldUp


type HoldUp
    = UserAttributes


type Problem
    = InvalidUrl
    | NoPageLoaded
