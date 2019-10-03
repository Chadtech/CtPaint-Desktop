module View.ColorBox exposing
    ( ColorBox
    , Option
    , fromColor
    , onClick
    , setSize
    , toHtml
    )

import Color exposing (Color)
import Css exposing (Style)
import Data.Size exposing (Size)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Color as ColorUtil
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Option msg
    = ExactSize Size
    | OnClick msg


type ColorBox msg
    = ColorBox { color : Color } (List (Option msg))


type alias Summary msg =
    { exactSize : Maybe Size
    , onClick : Maybe msg
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


onClick : msg -> ColorBox msg -> ColorBox msg
onClick =
    addOption << OnClick


setSize : Size -> ColorBox msg -> ColorBox msg
setSize =
    addOption << ExactSize



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option msg -> ColorBox msg -> ColorBox msg
addOption option (ColorBox model options) =
    ColorBox model (option :: options)


makeSummary : List (Option msg) -> Summary msg
makeSummary =
    let
        modifySummary : Option msg -> Summary msg -> Summary msg
        modifySummary option summary =
            case option of
                ExactSize size ->
                    { summary | exactSize = Just size }

                OnClick msg ->
                    { summary | onClick = Just msg }
    in
    List.foldr
        modifySummary
        { exactSize = Nothing
        , onClick = Nothing
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


fromColor : Color -> ColorBox msg
fromColor color =
    ColorBox
        { color = color }
        []


toHtml : ColorBox msg -> Html msg
toHtml (ColorBox { color } options) =
    let
        summary : Summary msg
        summary =
            makeSummary options

        constantAttrs : List (Attribute msg)
        constantAttrs =
            [ Attrs.css
                [ Style.indent
                , sizeStyle summary.exactSize
                , ColorUtil.toCssBackground color
                , Css.flex (Css.int 1)
                , pointerStyle (Nothing /= summary.onClick)
                ]
            ]

        conditionalAttrs : List (Attribute msg)
        conditionalAttrs =
            [ Maybe.map Events.onClick summary.onClick ]
                |> List.filterMap identity
    in
    Html.div
        (constantAttrs ++ conditionalAttrs)
        []


pointerStyle : Bool -> Style
pointerStyle clicking =
    if clicking then
        Css.cursor Css.pointer

    else
        CssUtil.noStyle


sizeStyle : Maybe Size -> Style
sizeStyle maybeSize =
    case maybeSize of
        Just size ->
            [ Style.width size.width
            , Style.height size.height
            ]
                |> Css.batch

        Nothing ->
            Style.fullWidth
