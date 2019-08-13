module Style exposing
    ( Index
    , Scale
    , borderBottom
    , bottomMargin
    , centerContent
    , divider
    , exactWidth
    , font
    , fontSmoothingNone
    , fullWidth
    , getScale
    , globals
    , height
    , i0
    , i1
    , i10
    , i2
    , i3
    , i4
    , i5
    , i6
    , i7
    , i8
    , i9
    , indent
    , margin
    , marginBottom
    , marginHorizontal
    , marginLeft
    , marginLeftSizes
    , marginRight
    , marginTop
    , marginVertical
    , noOutline
    , outdent
    , padding
    , paddingLeft
    , pit
    , pointer
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


padding : Index -> Style
padding index =
    getScale index paddingSizes


paddingSizes : Scale Style
paddingSizes =
    mapScale (toFloat >> px >> Css.padding) sizes


paddingLeft : Index -> Style
paddingLeft index =
    getScale index paddingLeftSizes


paddingLeftSizes : Scale Style
paddingLeftSizes =
    mapScale (toFloat >> px >> Css.paddingLeft) sizes


margin : Index -> Style
margin index =
    [ marginBottom index
    , marginTop index
    , marginLeft index
    , marginRight index
    ]
        |> Css.batch


bottomMargin : Style
bottomMargin =
    Css.marginBottom (px unit)


marginLeft : Index -> Style
marginLeft index =
    getScale index marginLeftSizes


marginTop : Index -> Style
marginTop index =
    getScale index marginTopSizes


marginBottom : Index -> Style
marginBottom index =
    getScale index marginBottomSizes


marginHorizontal : Index -> Style
marginHorizontal index =
    [ marginLeft index
    , marginRight index
    ]
        |> Css.batch


marginVertical : Index -> Style
marginVertical index =
    [ marginTop index
    , marginBottom index
    ]
        |> Css.batch


marginLeftSizes : Scale Style
marginLeftSizes =
    mapScale Css.marginLeft pxs


marginTopSizes : Scale Style
marginTopSizes =
    mapScale Css.marginTop pxs


marginBottomSizes : Scale Style
marginBottomSizes =
    mapScale Css.marginBottom pxs


marginRight : Index -> Style
marginRight index =
    getScale index marginRightSizes


marginRightSizes : Scale Style
marginRightSizes =
    mapScale (toFloat >> px >> Css.marginRight) sizes


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
    , Css.fontSize (px 32)
    ]
        |> Css.batch


fontSmoothingNone : Style
fontSmoothingNone =
    Css.property "-webkit-font-smoothing" "none"


indent : Style
indent =
    [ borderTop3 (px 2) solid Colors.content0
    , borderLeft3 (px 2) solid Colors.content0
    , borderRight3 (px 2) solid Colors.content2
    , borderBottom Colors.content2
    ]
        |> Css.batch


outdent : Style
outdent =
    [ borderTop3 (px 2) solid Colors.content2
    , borderLeft3 (px 2) solid Colors.content2
    , borderRight3 (px 2) solid Colors.content0
    , borderBottom Colors.content0
    ]
        |> Css.batch


borderBottom : Color -> Style
borderBottom =
    borderBottom3 (getScale i0 pxs) solid


type alias Scale v =
    Vector11 v


type alias Index =
    Vector11.Index


mapScale : (v -> w) -> Scale v -> Scale w
mapScale =
    Vector11.map


getScale : Index -> Scale v -> v
getScale =
    Vector11.get


sizes : Scale Int
sizes =
    Vector11.initializeFromInt
        (\i -> 2 ^ (i + 1))


pxs : Scale Px
pxs =
    mapScale (toFloat >> px) sizes


height : Index -> Style
height index =
    getScale index heightSizes


heightSizes : Scale Style
heightSizes =
    mapScale Css.height pxs


width : Index -> Style
width index =
    getScale index widthSizes


exactWidth : Float -> Style
exactWidth flWidth =
    Css.width (Css.px <| flWidth)


widthSizes : Scale Style
widthSizes =
    mapScale Css.width pxs


fullWidth : Style
fullWidth =
    Css.width (Css.pct 100)


i0 : Index
i0 =
    Index0


i1 : Index
i1 =
    Index1


i2 : Index
i2 =
    Index2


i3 : Index
i3 =
    Index3


i4 : Index
i4 =
    Index4


i5 : Index
i5 =
    Index5


i6 : Index
i6 =
    Index6


i7 : Index
i7 =
    Index7


i8 : Index
i8 =
    Index8


i9 : Index
i9 =
    Index9


i10 : Index
i10 =
    Index10


pointer : Style
pointer =
    cursor Css.pointer


noOutline : Style
noOutline =
    Css.outline Css.none


divider : Style
divider =
    [ borderLeft3 (px 2) solid Colors.content0
    , borderRight3 (px 2) solid Colors.content2
    , Css.width Css.zero
    , display inline
    ]
        |> Css.batch


centerContent : Style
centerContent =
    Css.justifyContent Css.center
