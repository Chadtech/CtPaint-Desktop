module View.Button exposing
    ( Button
    , Option
    , asDoubleWidth
    , asFullWidth
    , asHalfWidth
    , config
    , indent
    , isDisabled
    , makeTaller
    , noLabel
    , toHtml
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style



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


type alias Summary =
    { width : Width
    , indent : Maybe Bool
    , disabled : Bool
    , tall : Bool
    , label : Maybe String
    , backgroundColor : Maybe Css.Color
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


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
                    { summary | width = width }

                Indent indent_ ->
                    { summary | indent = Just indent_ }

                Disabled disabled ->
                    { summary | disabled = disabled }

                Tall tall ->
                    { summary | tall = tall }

                Label label ->
                    { summary | label = Just label }

                BackgroundColor color ->
                    { summary | backgroundColor = Just color }
    in
    List.foldr modifySummary
        { width = SingleWidth
        , indent = Nothing
        , disabled = False
        , tall = False
        , label = Nothing
        , backgroundColor = Nothing
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : msg -> String -> Button msg
config onClick label =
    Button
        { onClick = onClick }
        [ Label label ]


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
            [ indentStyle summary.indent
            , buttonHeight summary.tall
            , summary.backgroundColor
                |> Maybe.withDefault Colors.content1
                |> Css.backgroundColor
            , Css.color Colors.content4
            , Css.active [ Style.indent ]
            , buttonWidth summary
            , disabledStyle summary.disabled
            ]
        , Events.onClick onClick
        ]
        [ Html.text (Maybe.withDefault "" summary.label) ]


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
