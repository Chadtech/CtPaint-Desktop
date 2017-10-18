module Styles.Shared exposing (..)

import Css exposing (Color, hex)
import Html.CssHelpers exposing (withNamespace)


type Classes
    = Field
    | Point
    | Big
    | Card
    | CardBody
    | Header


appNameSpace : String
appNameSpace =
    "app-name"



-- COLORS --


backgroundx2 : Color
backgroundx2 =
    hex "#06120e"


backgroundx1 : Color
backgroundx1 =
    hex "#030907"


actualBlack : Color
actualBlack =
    hex "#000000"


offBlue : Color
offBlue =
    hex "#143b2e"


offBlueDarker : Color
offBlueDarker =
    hex "#071d17"


critical : Color
critical =
    hex "#f21d23"


good : Color
good =
    hex "#366317"


prettyBlue : Color
prettyBlue =
    hex "#175cfe"


importanterText : Color
importanterText =
    hex "#e3d34b"


importantText : Color
importantText =
    hex "#b39f4b"


pointier : Color
pointier =
    hex "#e0d6ca"


pointColor : Color
pointColor =
    hex "#b0a69a"


ignorable0 : Color
ignorable0 =
    hex "#807672"


ignorable1 : Color
ignorable1 =
    hex "#57524f"


ignorable2 : Color
ignorable2 =
    hex "#2c2826"


ignorable3 : Color
ignorable3 =
    hex "#131610"
