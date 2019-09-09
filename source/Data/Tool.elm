module Data.Tool exposing
    ( Tool(..)
    , init
    , initEraser
    , initFill
    , initHand
    , initLine
    , initPencil
    , initRectangle
    , initRectangleFilled
    , initSample
    , initSelect
    , initZoomIn
    , initZoomOut
    )

import Data.CanvasClick exposing (CanvasClick)
import Data.MouseButton exposing (MouseButton)
import Data.MouseDrag as MouseDrag exposing (MouseDrag)
import Data.PositionOfCanvas exposing (PositionOfCanvas)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Tool
    = Hand (MouseDrag.Initial PositionOfCanvas)
    | Sample
    | Fill
    | Select (MouseDrag.Initial CanvasClick)
    | ZoomIn
    | ZoomOut
    | Pencil (MouseDrag.Initial MouseButton)
    | Line (MouseDrag.Initial CanvasClick)
    | Rectangle (MouseDrag.Initial CanvasClick)
    | RectangleFilled (MouseDrag.Initial CanvasClick)
    | Eraser (MouseDrag.Initial CanvasClick)



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Tool
init =
    initPencil


initPencil : Tool
initPencil =
    Pencil MouseDrag.none


initHand : Tool
initHand =
    Hand MouseDrag.none


initSample : Tool
initSample =
    Sample


initFill : Tool
initFill =
    Fill


initSelect : Tool
initSelect =
    Select MouseDrag.none


initZoomIn : Tool
initZoomIn =
    ZoomIn


initZoomOut : Tool
initZoomOut =
    ZoomOut


initLine : Tool
initLine =
    Line MouseDrag.none


initRectangle : Tool
initRectangle =
    Rectangle MouseDrag.none


initRectangleFilled : Tool
initRectangleFilled =
    RectangleFilled MouseDrag.none


initEraser : Tool
initEraser =
    RectangleFilled MouseDrag.none
