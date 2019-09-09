module Data.CanvasPosition exposing (CanvasPosition)

{-| This is just a position, with the
assumption that (0,0) is the top
left corner of the canvas

Not to be confused with `PositionOfCanvas`, which
is the position of the canvas in the work area

-}

import Data.Position exposing (Position)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type CanvasPosition
    = CanvasPosition Position
