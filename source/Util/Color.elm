module Util.Color exposing
    ( ctPoint
    , ctPrettyBlue
    , ctRed
    , encode
    , toCssBackground
    , toHexString
    )

import Color exposing (Color)
import Css exposing (Style)
import Hex
import Json.Encode as Encode



-------------------------------------------------------------------------------
-- VALUES --
-------------------------------------------------------------------------------


ctPoint : Color
ctPoint =
    Color.rgb255 176 166 154


ctRed : Color
ctRed =
    Color.rgb255 242 29 35


ctPrettyBlue : Color
ctPrettyBlue =
    Color.rgb255 23 92 254



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


toHexString : Color -> String
toHexString color =
    let
        { red, green, blue } =
            Color.toRgba color

        toHex : Float -> String
        toHex fl =
            (fl * 255)
                |> floor
                |> Hex.toString
                |> String.padLeft 2 '0'
    in
    [ "#"
    , toHex red
    , toHex green
    , toHex blue
    ]
        |> String.concat


encode : Color -> Encode.Value
encode =
    toHexString >> Encode.string


toCssBackground : Color -> Style
toCssBackground color =
    color
        |> toHexString
        |> Css.property "background-color"
