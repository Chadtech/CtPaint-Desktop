port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Html.Custom
import Html.InitDrawing
import Html.Main
import Nav
import Page.About
import Page.Contact
import Page.Documentation
import Page.Error
import Page.ForgotPassword
import Page.Home
import Page.Login
import Page.Offline
import Page.Pricing
import Page.Register
import Page.ResetPassword
import Page.RoadMap
import Page.Settings
import Page.Splash
import Page.Verify
import Tos


port files : CssFileStructure -> Cmd msg


main : CssCompilerProgram
main =
    [ Page.Register.css
    , Page.Verify.css
    , Page.Login.css
    , Page.Error.css
    , Page.Settings.css
    , Html.Main.css
    , Page.Splash.css
    , Nav.css
    , Html.Custom.css
    , Page.Documentation.css
    , Page.Home.css
    , Page.Offline.css
    , Page.About.css
    , Page.Pricing.css
    , Page.Contact.css
    , Html.InitDrawing.css
    , Page.RoadMap.css
    , Page.ForgotPassword.css
    , Page.ResetPassword.css
    , Tos.css
    ]
        |> Css.File.compile
        |> (,) "./public/desktop-styles.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
