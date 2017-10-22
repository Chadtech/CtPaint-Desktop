module Styles.Shared exposing (..)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Util exposing ((:=))


type Classes
    = Field
    | Card
    | Body
    | Header
    | Selected
    | Null


appNameSpace : String
appNameSpace =
    "ctpaint-desktop"


cannotSelect : List Style
cannotSelect =
    [ "-webkit-user-select" := "none"
    , "-moz-user-select" := "none"
    , "-ms-user-select" := "none"
    , "user-select" := "none"
    ]
        |> List.map (\a b -> property a b)


indent : List Style
indent =
    [ borderTop (px 2) solid ignorable1
    , borderLeft (px 2) solid ignorable1
    , borderRight (px 2) solid ignorable3
    , borderBottom (px 2) solid ignorable3
    ]
        |> List.concat


outdent : List Style
outdent =
    [ borderTop (px 2) solid ignorable1
    , borderLeft (px 2) solid ignorable1
    , borderRight (px 2) solid ignorable3
    , borderBottom (px 2) solid ignorable3
    ]


basicFont : List Style
basicFont =
    [ fontFamilies [ "hfnss" ]
    , color point
    , property "-webkit-font-smoothing" "none"
    , fontSize (px 32)
    ]



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


point : Color
point =
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
