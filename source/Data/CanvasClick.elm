module Data.CanvasClick exposing (CanvasClick)

import Data.CanvasPosition exposing (CanvasPosition)
import Data.MouseButton exposing (MouseButton)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias CanvasClick =
    { position : CanvasPosition
    , mouseButton : MouseButton
    }
