module Data.MouseDrag exposing
    ( Initial
    , MouseDrag(..)
    , none
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type MouseDrag model
    = None
    | MouseDown model


{-| MouseDrags are about state while
the mouse is being dragged

Some mouse drags are really only about
remembering the initial state at the
beginning of the mouse drag

-}
type alias Initial state =
    MouseDrag state



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


none : MouseDrag model
none =
    None
