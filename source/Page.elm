module Page exposing (..)

import Page.Home as Home


type Page
    = Home Home.Model
    | Error Problem
    | Settings
    | Register
    | Login
    | Logout


type Problem
    = InvalidUrl
