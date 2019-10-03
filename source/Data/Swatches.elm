module Data.Swatches exposing
    ( Swatches
    , default
    , encode
    , setTop
    , turnLeft
    , turnRight
    )

import Color exposing (Color)
import Json.Encode as Encode
import Util.Color as ColorUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Swatches =
    { top : Color
    , left : Color
    , bottom : Color
    , right : Color
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


default : Swatches
default =
    { top = Color.black
    , left = ColorUtil.ctPrettyBlue
    , bottom = Color.white
    , right = ColorUtil.ctRed
    }


encode : Swatches -> Encode.Value
encode { top, left, bottom, right } =
    let
        colorField : String -> Color -> ( String, Encode.Value )
        colorField fieldName color =
            color
                |> ColorUtil.encode
                |> Tuple.pair fieldName
    in
    [ colorField "top" top
    , colorField "left" left
    , colorField "bottom" bottom
    , colorField "right" right
    ]
        |> Encode.object


setTop : Color -> Swatches -> Swatches
setTop color swatches =
    { swatches | top = color }


turnLeft : Swatches -> Swatches
turnLeft swatches =
    { top = swatches.left
    , left = swatches.bottom
    , bottom = swatches.right
    , right = swatches.top
    }


turnRight : Swatches -> Swatches
turnRight swatches =
    { top = swatches.right
    , left = swatches.top
    , bottom = swatches.left
    , right = swatches.bottom
    }
