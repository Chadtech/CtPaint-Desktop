module View.Button exposing
    ( Button
    , Option
    , asDoubleWidth
    , asDoubleWidthIf
    , asFullWidth
    , asHalfWidth
    , column
    , config
    , icon
    , indent
    , isDisabled
    , makeTaller
    , noLabel
    , row
    , rowWithStyles
    , toHtml
    , withBackgroundColor
    , withFatBorder
    , withSize
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Data.Size exposing (Size)
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Button msg
    = Button (Model msg) (List Option)


type alias Model msg =
    { onClick : msg }


type Width
    = HalfWidth
    | SingleWidth
    | DoubleWidth
    | FullWidth


type Option
    = Width Width
    | Indent Bool
    | Disabled Bool
    | Tall Bool
    | Label String
    | BackgroundColor Css.Color
    | FatBorder
    | Icon
    | AsExactSize Size


type Sizing
    = RegularSizing Width { tall : Bool }
    | ExactSize Size


type alias Summary =
    { indent : Maybe Bool
    , disabled : Bool
    , label : Maybe String
    , backgroundColor : Maybe Css.Color
    , fatBorder : Bool
    , iconFont : Bool
    , sizing : Sizing
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withSize : Size -> Button msg -> Button msg
withSize =
    addOption << AsExactSize


withFatBorder : Button msg -> Button msg
withFatBorder =
    addOption FatBorder


withBackgroundColor : Css.Color -> Button msg -> Button msg
withBackgroundColor =
    addOption << BackgroundColor


isDisabled : Bool -> Button msg -> Button msg
isDisabled =
    addOption << Disabled


withWidth : Width -> Button msg -> Button msg
withWidth =
    addOption << Width


makeTaller : Bool -> Button msg -> Button msg
makeTaller =
    addOption << Tall


asDoubleWidth : Button msg -> Button msg
asDoubleWidth =
    withWidth DoubleWidth


asDoubleWidthIf : Bool -> Button msg -> Button msg
asDoubleWidthIf condition =
    if condition then
        asDoubleWidth

    else
        identity


asSingleWidth : Button msg -> Button msg
asSingleWidth =
    withWidth SingleWidth


asFullWidth : Button msg -> Button msg
asFullWidth =
    withWidth FullWidth


asHalfWidth : Button msg -> Button msg
asHalfWidth =
    withWidth HalfWidth


indent : Bool -> Button msg -> Button msg
indent =
    addOption << Indent



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option -> Button msg -> Button msg
addOption option (Button model options) =
    Button model (option :: options)


optionsToSummary : List Option -> Summary
optionsToSummary =
    let
        modifySummary : Option -> Summary -> Summary
        modifySummary option summary =
            case option of
                Width width ->
                    { summary
                        | sizing =
                            case summary.sizing of
                                RegularSizing _ tall ->
                                    RegularSizing width tall

                                _ ->
                                    summary.sizing
                    }

                Indent indent_ ->
                    { summary | indent = Just indent_ }

                Disabled disabled ->
                    { summary | disabled = disabled }

                Tall tall ->
                    { summary
                        | sizing =
                            case summary.sizing of
                                RegularSizing width _ ->
                                    RegularSizing
                                        width
                                        { tall = tall }

                                _ ->
                                    summary.sizing
                    }

                Label label ->
                    { summary | label = Just label }

                BackgroundColor color ->
                    { summary | backgroundColor = Just color }

                FatBorder ->
                    { summary | fatBorder = True }

                Icon ->
                    modifySummary
                        (Width FullWidth)
                        { summary | iconFont = True }

                AsExactSize size ->
                    { summary | sizing = ExactSize size }
    in
    List.foldr modifySummary
        { indent = Nothing
        , disabled = False
        , label = Nothing
        , backgroundColor = Nothing
        , fatBorder = False
        , iconFont = False
        , sizing = RegularSizing SingleWidth { tall = False }
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : msg -> String -> Button msg
config onClick label =
    Button
        { onClick = onClick }
        [ Label label ]


icon : msg -> String -> Button msg
icon onClick iconStr =
    Button
        { onClick = onClick }
        [ Label iconStr, Icon ]


noLabel : msg -> Button msg
noLabel onClick =
    Button
        { onClick = onClick }
        []


toHtml : Button msg -> Html msg
toHtml (Button { onClick } options) =
    let
        summary : Summary
        summary =
            optionsToSummary options
    in
    Html.button
        [ Attrs.css
            [ indentStyle summary
            , sizingStyle summary.sizing
            , summary.backgroundColor
                |> Maybe.withDefault Colors.content1
                |> Css.backgroundColor
            , Css.color Colors.content4
            , Css.active [ Style.indent ]
            , disabledStyle summary.disabled
            , CssUtil.styleIf summary.iconFont iconStyle
            ]
        , Events.onClick onClick
        ]
        [ Html.text (Maybe.withDefault "" summary.label) ]


sizingStyle : Sizing -> Style
sizingStyle sizing =
    let
        buttonWidth : Width -> Style
        buttonWidth width =
            case width of
                HalfWidth ->
                    Style.width 6

                SingleWidth ->
                    Style.width 7

                DoubleWidth ->
                    Style.width 8

                FullWidth ->
                    Style.fullWidth

        buttonHeight : Bool -> Style
        buttonHeight tall =
            if tall then
                Style.height 6

            else
                Style.height 5
    in
    case sizing of
        RegularSizing width { tall } ->
            [ buttonHeight tall
            , buttonWidth width
            ]
                |> Css.batch

        ExactSize size ->
            [ Style.width size.width
            , Style.height size.height
            ]
                |> Css.batch


iconStyle : Style
iconStyle =
    [ Css.fontFamilies [ "icons" ]
    , Style.smallFontSize
    ]
        |> Css.batch


disabledStyle : Bool -> Style
disabledStyle disabled =
    if disabled then
        [ Css.backgroundColor Colors.content2
        , Css.active [ Style.outdent ]
        ]
            |> Css.batch

    else
        [ Css.hover [ Css.color Colors.content5 ]
        , Style.pointer
        ]
            |> Css.batch


indentStyle : Summary -> Style
indentStyle summary =
    case summary.indent of
        Nothing ->
            outdent summary

        Just True ->
            if summary.fatBorder then
                Style.indentWithWidth 2

            else
                Style.indent

        Just False ->
            outdent summary


outdent : Summary -> Style
outdent summary =
    if summary.fatBorder then
        Style.outdentWithWidth 2

    else
        Style.outdent


column : List (Button msg) -> List (Html msg)
column buttons =
    let
        buttonRow : List Style -> Button msg -> Html msg
        buttonRow styles button =
            Grid.row
                styles
                [ Grid.column
                    []
                    [ toHtml button ]
                ]
    in
    case buttons of
        [] ->
            []

        first :: rest ->
            buttonRow [] first
                :: List.map
                    (buttonRow [ Style.buttonMarginTop ])
                    rest


row : List (Button msg) -> Html msg
row =
    rowWithStyles []


rowWithStyles : List Style -> List (Button msg) -> Html msg
rowWithStyles extraRowStyles buttons =
    let
        buttonColumn : List Style -> Button msg -> Grid.Column msg
        buttonColumn extraStyles button =
            Grid.column
                (Grid.columnShrink :: extraStyles)
                [ toHtml button ]
    in
    Grid.row (Style.centerContent :: extraRowStyles) <|
        case buttons of
            first :: rest ->
                buttonColumn [] first
                    :: List.map
                        (buttonColumn [ Style.buttonMarginLeft ])
                        rest

            [] ->
                []
