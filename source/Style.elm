module Style exposing
    ( borderBottom
    , centerContent
    , exactWidth
    , font
    , fontSmoothingNone
    , fullHeight
    , fullWidth
    , globals
    , height
    , indent
    , margin
    , marginBottom
    , marginHorizontal
    , marginLeft
    , marginRight
    , marginTop
    , marginVertical
    , noBackground
    , noBorder
    , noOutline
    , noOverflow
    , outdent
    , padding
    , paddingBottom
    , paddingHorizontal
    , paddingLeft
    , paddingRight
    , pit
    , pointer
    , problemBackground
    , pxStr
    , relative
    , sizePx
    , verticalDivider
    , width
    )

import Chadtech.Colors as Colors
import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled exposing (Html)


globals : Html msg
globals =
    [ Css.Global.p
        [ Css.color Colors.content4
        , fontSmoothingNone
        , font
        ]
    , Css.Global.button
        [ font
        , noOutline
        , pointer
        , fontSmoothingNone
        ]
    , Css.Global.everything
        [ Css.boxSizing Css.borderBox
        , Css.margin zero
        , Css.padding zero
        ]
    ]
        |> global


padding : Int -> Style
padding =
    Css.padding << sizePx


paddingLeft : Int -> Style
paddingLeft =
    Css.paddingLeft << sizePx


paddingRight : Int -> Style
paddingRight =
    Css.paddingRight << sizePx


paddingBottom : Int -> Style
paddingBottom =
    Css.paddingBottom << sizePx


margin : Int -> Style
margin size =
    [ marginBottom size
    , marginTop size
    , marginLeft size
    , marginRight size
    ]
        |> Css.batch


marginLeft : Int -> Style
marginLeft =
    Css.marginLeft << sizePx


marginTop : Int -> Style
marginTop =
    Css.marginTop << sizePx


marginBottom : Int -> Style
marginBottom =
    Css.marginBottom << sizePx


marginHorizontal : Int -> Style
marginHorizontal size =
    [ marginLeft size
    , marginRight size
    ]
        |> Css.batch


paddingHorizontal : Int -> Style
paddingHorizontal size =
    [ paddingLeft size
    , paddingRight size
    ]
        |> Css.batch


marginVertical : Int -> Style
marginVertical size =
    [ marginTop size
    , marginBottom size
    ]
        |> Css.batch


marginRight : Int -> Style
marginRight =
    Css.marginRight << sizePx


unit : Float
unit =
    8


font : Style
font =
    hfnss


pit : Style
pit =
    [ indent
    , Css.backgroundColor Colors.background1
    ]
        |> Css.batch


hfnss : Style
hfnss =
    [ Css.fontFamilies [ "HFNSS" ]
    , Css.fontSize (sizePx 5)
    ]
        |> Css.batch


fontSmoothingNone : Style
fontSmoothingNone =
    Css.property "-webkit-font-smoothing" "none"


indent : Style
indent =
    [ borderTop3 (sizePx 1) solid Colors.content0
    , borderLeft3 (sizePx 1) solid Colors.content0
    , borderRight3 (sizePx 1) solid Colors.content2
    , borderBottom Colors.content2
    ]
        |> Css.batch


outdent : Style
outdent =
    [ borderTop3 (sizePx 1) solid Colors.content2
    , borderLeft3 (sizePx 1) solid Colors.content2
    , borderRight3 (sizePx 1) solid Colors.content0
    , borderBottom Colors.content0
    ]
        |> Css.batch


borderBottom : Color -> Style
borderBottom =
    borderBottom3 (sizePx 1) solid


sizePx : Int -> Css.Px
sizePx =
    scale >> toFloat >> Css.px


pxStr : Int -> String
pxStr i =
    String.fromInt (scale i) ++ "px"


height : Int -> Style
height =
    Css.height << sizePx


width : Int -> Style
width =
    Css.width << sizePx


exactWidth : Float -> Style
exactWidth flWidth =
    Css.width (Css.px <| flWidth)


fullWidth : Style
fullWidth =
    Css.width (Css.pct 100)


fullHeight : Style
fullHeight =
    Css.height (Css.pct 100)


pointer : Style
pointer =
    cursor Css.pointer


noOutline : Style
noOutline =
    Css.outline Css.none


verticalDivider : Style
verticalDivider =
    [ borderLeft3 (sizePx 1) solid Colors.content0
    , borderRight3 (sizePx 1) solid Colors.content2
    , Css.width Css.zero
    , display inline
    ]
        |> Css.batch


horizontalDivider : Style
horizontalDivider =
    indent


centerContent : Style
centerContent =
    Css.justifyContent Css.center


scale : Int -> Int
scale degree =
    2 ^ degree


noBorder : Style
noBorder =
    Css.property "border" "none"


noBackground : Style
noBackground =
    Css.property "background" "none"


relative : Style
relative =
    Css.position Css.relative


noOverflow : Style
noOverflow =
    Css.overflow Css.hidden


problemBackground : Style
problemBackground =
    Css.backgroundColor Colors.problem0
