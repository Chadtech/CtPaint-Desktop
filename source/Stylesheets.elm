port module Stylesheets exposing (..)

import Css.File exposing (CssCompilerProgram, CssFileStructure)
import Styles
import Util exposing ((:=))


port files : CssFileStructure -> Cmd msg


fileStructure : CssFileStructure
fileStructure =
    [ "./public/desktop-styles.css" := Css.File.compile [ Styles.css ] ]
        |> Css.File.toFileStructure


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
