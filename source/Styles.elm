module Styles exposing (css)

import Css exposing (..)
import Css.Elements exposing (body, p)
import Css.Namespace exposing (namespace)
import Styles.Shared exposing (..)


css =
    (stylesheet << namespace appNameSpace)
        [ body
            [ backgroundColor backgroundx2
            , margin zero
            , padding zero
            ]
        , card
        , point
        , header
        , field
        ]


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
    , withChild body
        [ marginTop (px 25) ]
    ]
        |> class Card


button : Snippet
button =
    let
        mixins =
            [ outdent
            , active indent
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
    , class Selected [ indent ]
    , class Null
        [ backgroundColor ignorable1
        , hover [ color point ]
        , active outdent
        ]
    ]
        |> List.append mixins
        |> a


point : Snippet
point =
    let
        mixins =
            [ basicFont ]
    in
    [ margin zero
    , padding zero
    ]
        |> List.append mixins
        |> p
