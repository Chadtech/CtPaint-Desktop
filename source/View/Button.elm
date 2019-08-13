module View.Button exposing
    ( Button
    , Option
    , asDoubleWidth
    , asHalfWidth
    , config
    , indent
    , isDisabled
    , makeTaller
    , toHtml
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Button msg
    = Button (Model msg)


type alias Model msg =
    { onClick : msg
    , label : String
    , options : List Option
    }


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


type alias Summary =
    { width : Width
    , indent : Maybe Bool
    , disabled : Bool
    , tall : Bool
    }



-------------------------------------------------------------------------------
-- OPTIONS --
-------------------------------------------------------------------------------


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


asSingleWidth : Button msg -> Button msg
asSingleWidth =
    withWidth SingleWidth


asFullWidth : Button msg -> Button msg
asFullWidth =
    withWidth FullWidth


asHalfWidth : Button msg -> Button msg
asHalfWidth =
    withWidth HalfWidth


addOption : Option -> Button msg -> Button msg
addOption option (Button model) =
    Button { model | options = option :: model.options }


indent : Bool -> Button msg -> Button msg
indent =
    addOption << Indent



-------------------------------------------------------------------------------
-- SUMMARY --
-------------------------------------------------------------------------------


optionsToSummary : List Option -> Summary
optionsToSummary =
    let
        modifySummary : Option -> Summary -> Summary
        modifySummary option summary =
            case option of
                Width width ->
                    { summary | width = width }

                Indent indent_ ->
                    { summary | indent = Just indent_ }

                Disabled disabled ->
                    { summary | disabled = disabled }

                Tall tall ->
                    { summary | tall = tall }
    in
    List.foldr modifySummary
        { width = SingleWidth
        , indent = Nothing
        , disabled = False
        , tall = False
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : msg -> String -> Button msg
config onClick label =
    Button
        { onClick = onClick
        , label = label
        , options = []
        }


toHtml : Button msg -> Html msg
toHtml (Button { onClick, label, options }) =
    let
        summary : Summary
        summary =
            optionsToSummary options
    in
    Html.button
        [ Attrs.css
            [ indentStyle summary.indent
            , Style.font
            , buttonHeight summary.tall
            , Css.backgroundColor Colors.content1
            , Css.color Colors.content4
            , Style.fontSmoothingNone
            , Style.noOutline
            , Css.active [ Style.indent ]
            , Css.hover [ Css.color Colors.content5 ]
            , Style.pointer
            , buttonWidth summary
            , disabledStyle summary.disabled
            ]
        , Events.onClick onClick
        ]
        [ Html.text label ]


disabledStyle : Bool -> Style
disabledStyle disabled =
    if disabled then
        [ Css.backgroundColor Colors.content0
        , Css.active [ Style.outdent ]
        ]
            |> Css.batch

    else
        CssUtil.noStyle


indentStyle : Maybe Bool -> Style
indentStyle maybeIndent =
    case maybeIndent of
        Nothing ->
            Style.outdent

        Just True ->
            Style.indent

        Just False ->
            Style.outdent


buttonWidth : Summary -> Style
buttonWidth summary =
    case summary.width of
        HalfWidth ->
            Style.width Style.i5

        SingleWidth ->
            Style.width Style.i6

        DoubleWidth ->
            Style.width Style.i7

        FullWidth ->
            Style.fullWidth


buttonHeight : Bool -> Style
buttonHeight tall =
    if tall then
        Style.height Style.i5

    else
        Style.height Style.i4
