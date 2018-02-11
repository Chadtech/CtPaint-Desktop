module Page exposing (..)

import Page.Home as Home
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.Settings as Settings
import Page.Verify as Verify


type Page
    = Home Home.Model
    | InitDrawing InitDrawing.Model
    | About
    | Error Problem
    | Settings Settings.Model
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
