module Style exposing
    ( bodyWidth
    , borderBottom
    , buttonMarginBottom
    , buttonMarginLeft
    , buttonMarginRight
    , buttonMarginTop
    , buttonPaddingHorizontal
    , centerContent
    , exactWidth
    , fieldMarginBelow
    , fieldMarginTop
    , fieldSeperationSize
    , font
    , fontSmoothingNone
    , footerPaddingBottom
    , fullHeight
    , fullWidth
    , globals
    , grow
    , height
    , indent
    , indentWithWidth
    , leftJustifyContent
    , margin
    , marginBottom
    , marginHorizontal
    , marginLeft
    , marginRight
    , marginTop
    , marginVertical
    , maxHeight
    , maxWidth
    , noBackground
    , noBorder
    , noOutline
    , noOverflow
    , outdent
    , outdentWithWidth
    , padding
    , paddingBottom
    , paddingHorizontal
    , paddingLeft
    , paddingRight
    , paddingTop
    , pit
    , pointer
    , problemBackground
    , pxStr
    , relative
    , scroll
    , sectionMarginHorizontal
    , sectionMarginLeft
    , sectionMarginRight
    , sectionMarginTop
    , sectionMarginVertical
    , sectionPaddingTop
    , sizePx
    , smallFontSize
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


paddingTop : Int -> Style
paddingTop =
    Css.paddingTop << sizePx


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


fieldSeperationSize : Int
fieldSeperationSize =
    1


sectionSeperationSize : Int
sectionSeperationSize =
    3


footerSize : Int
footerSize =
    6


footerPaddingBottom : Style
footerPaddingBottom =
    paddingBottom footerSize


bodySize : Int
bodySize =
    10


bodyWidth : Style
bodyWidth =
    width bodySize


sectionMarginLeft : Style
sectionMarginLeft =
    marginLeft sectionSeperationSize


sectionMarginTop : Style
sectionMarginTop =
    marginTop sectionSeperationSize


sectionMarginBottom : Style
sectionMarginBottom =
    marginBottom sectionSeperationSize


sectionMarginRight : Style
sectionMarginRight =
    marginRight sectionSeperationSize


sectionMarginHorizontal : Style
sectionMarginHorizontal =
    [ sectionMarginLeft
    , sectionMarginRight
    ]
        |> Css.batch


sectionMarginVertical : Style
sectionMarginVertical =
    [ sectionMarginTop
    , sectionMarginBottom
    ]
        |> Css.batch


sectionPaddingTop : Style
sectionPaddingTop =
    paddingTop sectionSeperationSize


fieldPaddingRight : Style
fieldPaddingRight =
    paddingRight fieldSeperationSize


fieldMarginTop : Style
fieldMarginTop =
    marginTop fieldSeperationSize


fieldMarginBelow : Style
fieldMarginBelow =
    marginBottom fieldSeperationSize


buttonPaddingHorizontal : Style
buttonPaddingHorizontal =
    paddingHorizontal buttonSeparationSize


buttonMarginLeft : Style
buttonMarginLeft =
    marginLeft buttonSeparationSize


buttonMarginRight : Style
buttonMarginRight =
    marginRight buttonSeparationSize


buttonMarginBottom : Style
buttonMarginBottom =
    marginBottom buttonSeparationSize


buttonMarginTop : Style
buttonMarginTop =
    marginTop buttonSeparationSize


buttonSeparationSize : Int
buttonSeparationSize =
    2


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
    , normalFontSize
    ]
        |> Css.batch


fontSize : Int -> Style
fontSize =
    Css.fontSize << sizePx


normalFontSize : Style
normalFontSize =
    fontSize 5


smallFontSize : Style
smallFontSize =
    fontSize 4


fontSmoothingNone : Style
fontSmoothingNone =
    Css.property "-webkit-font-smoothing" "none"


indent : Style
indent =
    indentWithWidth 1


indentWithWidth : Int -> Style
indentWithWidth w =
    [ borderTop3 (sizePx w) solid Colors.content0
    , borderLeft3 (sizePx w) solid Colors.content0
    , borderRight3 (sizePx w) solid Colors.content2
    , borderBottomAtWidth w Colors.content2
    ]
        |> Css.batch


outdent : Style
outdent =
    outdentWithWidth 1


outdentWithWidth : Int -> Style
outdentWithWidth w =
    [ borderTop3 (sizePx w) solid Colors.content2
    , borderLeft3 (sizePx w) solid Colors.content2
    , borderRight3 (sizePx w) solid Colors.content0
    , borderBottomAtWidth w Colors.content0
    ]
        |> Css.batch


borderBottom : Color -> Style
borderBottom =
    borderBottomAtWidth 1


borderBottomAtWidth : Int -> Color -> Style
borderBottomAtWidth w =
    borderBottom3 (sizePx w) solid


sizePx : Int -> Css.Px
sizePx =
    scale >> toFloat >> Css.px


pxStr : Int -> String
pxStr i =
    String.fromInt (scale i) ++ "px"


height : Int -> Style
height =
    Css.height << sizePx


maxWidth : Int -> Style
maxWidth =
    Css.maxWidth << sizePx


maxHeight : Int -> Style
maxHeight =
    Css.maxHeight << sizePx


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


centerContent : Style
centerContent =
    Css.justifyContent Css.center


leftJustifyContent : Style
leftJustifyContent =
    Css.justifyContent Css.left


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


scroll : Style
scroll =
    Css.overflow Css.scroll


problemBackground : Style
problemBackground =
    Css.backgroundColor Colors.problem0


grow : Style
grow =
    Css.flex (Css.int 1)
