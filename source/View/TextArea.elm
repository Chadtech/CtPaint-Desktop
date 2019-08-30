module View.TextArea exposing
    ( config
    , isDisabled
    , readOnly
    , toHtml
    , withFullHeight
    , withHeight
    , withPlaceholder
    )

import Chadtech.Colors as Colors
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { value : String
    }


type Option msg
    = OnInput (String -> msg)
    | Height Int
    | Disabled Bool
    | Placeholder String
    | FullHeight


type TextArea msg
    = TextArea Model (List (Option msg))


type alias Summary msg =
    { onInput : Maybe (String -> msg)
    , fixedHeight : Maybe Int
    , placeholder : Maybe String
    , disabled : Bool
    , fullheight : Bool
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withHeight : Int -> TextArea msg -> TextArea msg
withHeight =
    addOption << Height


withPlaceholder : String -> TextArea msg -> TextArea msg
withPlaceholder =
    addOption << Placeholder


isDisabled : Bool -> TextArea msg -> TextArea msg
isDisabled =
    addOption << Disabled


withFullHeight : TextArea msg -> TextArea msg
withFullHeight =
    addOption FullHeight



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option msg -> TextArea msg -> TextArea msg
addOption option (TextArea model options) =
    TextArea model (option :: options)


optionsToSummary : List (Option msg) -> Summary msg
optionsToSummary =
    let
        modifySummary : Option msg -> Summary msg -> Summary msg
        modifySummary option summary =
            case option of
                OnInput msg ->
                    { summary | onInput = Just msg }

                Height int ->
                    { summary | fixedHeight = Just int }

                Disabled disabled ->
                    { summary | disabled = disabled }

                Placeholder str ->
                    { summary | placeholder = Just str }

                FullHeight ->
                    { summary | fullheight = True }
    in
    List.foldr
        modifySummary
        { onInput = Nothing
        , fixedHeight = Nothing
        , placeholder = Nothing
        , disabled = False
        , fullheight = False
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


readOnly : String -> TextArea msg
readOnly value =
    TextArea { value = value } []


config : (String -> msg) -> String -> TextArea msg
config onInput value =
    TextArea
        { value = value
        }
        [ OnInput onInput ]


toHtml : TextArea msg -> Html msg
toHtml (TextArea { value } options) =
    let
        summary : Summary msg
        summary =
            optionsToSummary options

        attributes : List (Attribute msg)
        attributes =
            [ Attrs.css
                [ Css.color Colors.content4
                , Style.fontSmoothingNone
                , Style.fullWidth
                , Style.font
                , Style.padding 2
                , Style.noOutline
                , Style.pit
                , CssUtil.styleIf
                    summary.disabled
                    (Css.backgroundColor Colors.content2)
                , CssUtil.styleMaybe
                    Style.height
                    summary.fixedHeight
                , CssUtil.styleIf
                    summary.fullheight
                    Style.fullHeight
                ]
            , Attrs.spellcheck False
            , Attrs.value value
            ]

        conditionalAttributes : List (Attribute msg)
        conditionalAttributes =
            [ summary.onInput
                |> Maybe.map Events.onInput
            , summary.placeholder
                |> Maybe.map Attrs.placeholder
            ]
                |> List.filterMap identity
    in
    Html.textarea
        (attributes ++ conditionalAttributes)
        []
