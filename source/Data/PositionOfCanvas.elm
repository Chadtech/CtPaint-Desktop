module Data.PositionOfCanvas exposing (PositionOfCanvas)

{-| This is the position of the canvas on
the work area.

Not to be confused with `CanvasPosition`, which
is a position relative to the canvas itself

-}

import Data.WorkareaPosition exposing (WorkareaPosition)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type PositionOfCanvas
    = PositionOfCanvas WorkareaPosition
