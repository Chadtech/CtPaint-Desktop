module Data.Size exposing
    ( Size
    , toString
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


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
