module Style exposing
    ( borderBottom
    , centerContent
    , divider
    , exactWidth
    , font
    , fontSmoothingNone
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
    , noOutline
    , outdent
    , padding
    , paddingLeft
    , pit
    , pointer
    , sizePx
    , width
    )

import Chadtech.Colors as Colors
import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled exposing (Html)
import Vector11 exposing (Index(..), Vector11)


globals : Html msg
globals =
    [ Css.Global.p
        [ Css.color Colors.content4
        , fontSmoothingNone
        , font
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
    Css.marginTop << sizePx


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


marginVertical : Int -> Style
marginVertical index =
    [ marginTop index
    , marginBottom index
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
    , Css.fontSize (Css.px 32)
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


pointer : Style
pointer =
    cursor Css.pointer


noOutline : Style
noOutline =
    Css.outline Css.none


divider : Style
divider =
    [ borderLeft3 (sizePx 2) solid Colors.content0
    , borderRight3 (sizePx 2) solid Colors.content2
    , Css.width Css.zero
    , display inline
    ]
        |> Css.batch


centerContent : Style
centerContent =
    Css.justifyContent Css.center


scale : Int -> Int
scale degree =
    2 ^ degree
