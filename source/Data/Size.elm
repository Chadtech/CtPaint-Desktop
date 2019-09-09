module Data.Size exposing
    ( Size
    , center
    , toString
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------

import Data.Position exposing (Position)


type alias Size =
    { width : Int
    , height : Int
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


toString : Size -> String
toString { width, height } =
    [ "w"
    , String.fromInt width
    , "h"
    , String.fromInt height
    ]
        |> String.concat


center : Size -> Position
center size =
    { x = size.width // 2
    , y = size.height // 2
    }
