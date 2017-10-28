module Styles exposing (css)

import Css exposing (..)
import Css.Elements exposing (a, body, p)
import Css.Namespace exposing (namespace)
import Html.CssHelpers
import Util exposing ((:=))


helpers =
    Html.CssHelpers.withNamespace "desktop"


type Classes
    = Field
    | Card
    | Body
    | Header
    | Selected
    | Null


appNamespace : String
appNamespace =
    "desktop"


css =
    [ body
        [ backgroundColor backgroundx2
        , margin zero
        , padding zero
        ]
    , card
    , point
    , header
    ]
        |> namespace appNamespace
        |> stylesheet


header : Snippet
header =
    [ backgroundColor pointColor
    , color ignorable3
    , property "-webkit-font-smoothing" "none"
    , fontSize (px 32)
    , fontFamilies [ "hfnss" ]
    , height (px 25)
    , margin zero
    , padding zero
    , position absolute
    , top (px 2)
    , left (px 2)
    , width (px 510)
    , lineHeight (px 25)
    , paddingLeft (px 2)
    ]
        |> class Header


card : Snippet
card =
    [ backgroundColor ignorable2
    , borderTop3 (px 2) solid ignorable1
    , borderLeft3 (px 2) solid ignorable1
    , borderRight3 (px 2) solid ignorable3
    , borderBottom3 (px 2) solid ignorable3
    , width (px 500)
    , top (pct 50)
    , left (pct 50)
    , transform (translate2 (pct -50) (pct -50))
    , position absolute
    , padding (px 8)
    , children
        [ class Body
            [ marginTop (px 25) ]
        ]
    ]
        |> class Card


button : Snippet
button =
    let
        mixins =
            [ outdent
            , [ active indent ]
            , basicFont
            , cannotSelect
            ]
                |> List.concat
    in
    [ padding zero
    , textDecoration none
    , backgroundColor ignorable2
    , display inlineBlock
    , padding4 (px 4) (px 8) (px 8) (px 4)
    , cursor pointer
    , hover [ color pointier ]
    , withClass Selected indent
    , withClass Null
        [ backgroundColor ignorable1
        , hover [ color pointColor ]
        , active outdent
        ]
    ]
        |> List.append mixins
        |> a


point : Snippet
point =
    [ margin zero
    , padding zero
    ]
        |> List.append basicFont
        |> p



-- HELPERS --


cannotSelect : List Style
cannotSelect =
    [ "-webkit-user-select" := "none"
    , "-moz-user-select" := "none"
    , "-ms-user-select" := "none"
    , "user-select" := "none"
    ]
        |> List.map (uncurry property)


indent : List Style
indent =
    [ borderTop3 (px 2) solid ignorable1
    , borderLeft3 (px 2) solid ignorable1
    , borderRight3 (px 2) solid ignorable3
    , borderBottom3 (px 2) solid ignorable3
    ]


outdent : List Style
outdent =
    [ borderTop3 (px 2) solid ignorable1
    , borderLeft3 (px 2) solid ignorable1
    , borderRight3 (px 2) solid ignorable3
    , borderBottom3 (px 2) solid ignorable3
    ]


basicFont : List Style
basicFont =
    [ fontFamilies [ "hfnss" ]
    , color pointColor
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
