module Page exposing (..)

import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.Register as Register
import Page.Verify as Verify


type Page
    = Home Home.Model
    | Error Problem
    | Settings
    | Register Register.Model
    | Login Login.Model
    | Logout Logout.Model
    | Verify Verify.Model
    | Loading HoldUp


type HoldUp
    = UserAttributes


type Problem
    = InvalidUrl
    | NoPageLoaded
    | FlagsDecoderFailed String
    | Offline
