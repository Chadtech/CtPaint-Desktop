module Data.Palette exposing
    ( Palette
    , addColor
    , default
    , get
    , toList
    )

import Array exposing (Array)
import Color exposing (Color)
import Util.Color as ColorUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Palette
    = Palette (Array Color)



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


default : Palette
default =
    [ ColorUtil.ctPoint
    , Color.black
    , Color.white
    , Color.rgb255 101 92 74
    , Color.rgb255 85 96 45
    , Color.rgb255 172 214 48
    , Color.rgb255 221 201 142
    , Color.rgb255 243 210 21
    , Color.rgb255 240 146 50
    , Color.rgb255 255 91 49
    , Color.rgb255 212 51 27
    , ColorUtil.ctRed
    , Color.rgb255 252 164 132
    , Color.rgb255 230 121 166
    , Color.rgb255 80 0 87
    , Color.rgb255 240 224 214
    , Color.rgb255 255 255 238
    , Color.rgb255 157 144 136
    , Color.rgb255 50 54 128
    , Color.rgb255 36 33 157
    , Color.rgb255 0 47 167
    , ColorUtil.ctPrettyBlue
    , Color.rgb255 10 186 181
    , Color.rgb255 159 170 210
    , Color.rgb255 214 218 240
    , Color.rgb255 238 242 255
    , Color.rgb255 157 212 147
    , Color.rgb255 170 211 13
    , Color.rgb255 60 182 99
    , Color.rgb255 10 202 26
    , Color.rgb255 201 207 215
    ]
        |> Array.fromList
        |> Palette


toList : Palette -> List Color
toList (Palette array) =
    Array.toList array


get : Int -> Palette -> Maybe Color
get index (Palette array) =
    Array.get index array


addColor : Palette -> Palette
addColor (Palette array) =
    Array.push Color.white array
        |> Palette
