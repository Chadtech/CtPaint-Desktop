port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Html.Custom
import Html.Main
import Nav
import Page.About
import Page.Contact
import Page.Error
import Page.Home
import Page.InitDrawing
import Page.Login
import Page.Offline
import Page.Pricing
import Page.Register
import Page.Settings
import Page.Splash
import Page.Verify


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
    , Page.Home.css
    , Page.Offline.css
    , Page.About.css
    , Page.Pricing.css
    , Page.Contact.css
    , Page.InitDrawing.css
    ]
        |> Css.File.compile
        |> (,) "./public/desktop-styles.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
