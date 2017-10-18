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
        , cardBody
        , point
        , header
        ]


header : Snippet
header =
    class Header
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


cardBody : Snippet
cardBody =
    class CardBody
        [ marginTop (px 25) ]


card : Snippet
card =
    class Card
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
        ]


point : Snippet
point =
    p
        [ fontFamilies [ "hfnss" ]
        , color pointColor
        , property "-webkit-font-smoothing" "none"
        , fontSize (px 32)
        , margin zero
        , padding zero
        , withClass Big
            [ fontSize (em 4) ]
        ]
