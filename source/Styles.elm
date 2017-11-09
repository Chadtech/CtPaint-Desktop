module Styles exposing (Classes(..), css, helpers)

import Chadtech.Colors exposing (..)
import Css exposing (..)
import Css.Elements exposing (a, body, form, p)
import Css.Namespace exposing (namespace)
import Html.CssHelpers exposing (Namespace)
import Util exposing ((:=))


helpers : Namespace String class id msg
helpers =
    Html.CssHelpers.withNamespace appNamespace


type Classes
    = Field
    | Card
    | Submit
    | Solitary
    | Body
    | Header
    | Verify
    | Selected
    | Long
    | Null
    | Error
    | HasBottomMargin
    | TextAlignCenter
    | SpinnerContainer


appNamespace : String
appNamespace =
    "desktop"


css : Stylesheet
css =
    [ body
        [ backgroundColor backgroundx2
        , margin zero
        , padding zero
        ]
    , card
    , p <|
        List.append basicFont
            [ margin zero
            , padding zero
            ]
    , header
    , input
    , errorZone
    , button
    , submit
    , field
    , form [ margin (px 0) ]
    , class HasBottomMargin
        [ marginBottom (px 8) ]
    , class TextAlignCenter
        [ textAlign center ]
    , spinnerContainer
    ]
        |> namespace appNamespace
        |> stylesheet


spinnerContainer : Snippet
spinnerContainer =
    [ position relative
    , backgroundColor backgroundx2
    , height (px 16)
    , overflow hidden
    , width (px 200)
    , margin auto
    ]
        |> List.append indent
        |> class SpinnerContainer


field : Snippet
field =
    [ marginBottom (px 8)
    , children
        [ p
            [ display inlineBlock
            , width (px 120)
            , textAlign left
            , withClass Long
                [ width (px 180) ]
            ]
        ]
    ]
        |> class Field


submit : Snippet
submit =
    [ margin auto
    , display table
    ]
        |> class Submit


input : Snippet
input =
    [ backgroundColor backgroundx2
    , outline none
    , fontSize (em 2)
    , fontFamilies [ "hfnss" ]
    , color point
    , property "-webkit-font-smoothing" "none"
    , margin (px 0)
    , padding (px 0)
    , withClass Long
        [ width (px 300) ]
    ]
        |> List.append indent
        |> Css.Elements.input


errorZone : Snippet
errorZone =
    [ marginBottom (px 8)
    , backgroundColor lowWarning
    , padding (px 4)
    ]
        |> class Error


header : Snippet
header =
    [ backgroundColor point
    , height (px 25)
    , width (calc (pct 100) minus (px 8))
    , position absolute
    , padding (px 2)
    , margin (px 2)
    , lineHeight (px 25)
    , paddingLeft (px 2)
    , children
        [ p
            [ color ignorable3
            , cursor default
            , margin (px 0)
            , display inlineBlock
            ]
        ]
    ]
        |> class Header


card : Snippet
card =
    [ backgroundColor ignorable2
    , borderTop3 (px 2) solid ignorable1
    , borderLeft3 (px 2) solid ignorable1
    , borderRight3 (px 2) solid ignorable3
    , borderBottom3 (px 2) solid ignorable3
    , children
        [ class Body
            [ marginTop (px 31)
            , padding (px 8)
            , children
                []
            ]
        ]
    , withClass Solitary
        [ top (pct 50)
        , left (pct 50)
        , position absolute
        , transform (translate2 (pct -50) (pct -50))
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
    , padding4 (px 4) (px 8) (px 4) (px 8)
    , cursor pointer
    , hover [ color pointier ]
    , withClass Selected indent
    , withClass Null
        [ backgroundColor ignorable1
        , hover [ color point ]
        , active outdent
        ]
    ]
        |> List.append mixins
        |> a



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
    [ borderTop3 (px 2) solid ignorable3
    , borderLeft3 (px 2) solid ignorable3
    , borderRight3 (px 2) solid ignorable1
    , borderBottom3 (px 2) solid ignorable1
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
    , color point
    , property "-webkit-font-smoothing" "none"
    , fontSize (px 32)
    ]
