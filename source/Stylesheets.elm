port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Html.Custom
import Page.Login
import Page.Register
import Page.Verify


port files : CssFileStructure -> Cmd msg


main : CssCompilerProgram
main =
    [ Page.Register.css
    , Page.Verify.css
    , Page.Login.css
    , Html.Custom.css
    ]
        |> Css.File.compile
        |> (,) "./public/desktop-styles.css"
        |> List.singleton
        |> Css.File.toFileStructure
        |> Css.File.compiler files
