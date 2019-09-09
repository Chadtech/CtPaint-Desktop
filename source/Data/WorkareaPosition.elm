module Data.WorkareaPosition exposing (WorkareaPosition)

{-| This is just a position, with the
assumption that (0,0) is the top left
corner of the work area.
-}

import Data.Position exposing (Position)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type WorkareaPosition
    = WorkareaPosition Position
