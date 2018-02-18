module Page exposing (..)

import Page.Contact as Contact
import Page.ForgotPassword as ForgotPassword
import Page.Home as Home
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
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
    | Logout Logout.Model
    | Verify Verify.Model
    | Splash
    | Offline
    | Loading HoldUp
    | Error Problem


type HoldUp
    = UserAttributes


type Problem
    = InvalidUrl
    | NoPageLoaded
