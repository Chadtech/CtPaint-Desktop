module View.TextArea exposing
    ( config
    , readOnly
    , toHtml
    , withHeight
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


type TextArea msg
    = TextArea Model (List (Option msg))


type alias Summary msg =
    { onInput : Maybe (String -> msg)
    , fixedHeight : Maybe Int
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withHeight : Int -> TextArea msg -> TextArea msg
withHeight =
    addOption << Height



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
    in
    List.foldr
        modifySummary
        { onInput = Nothing
        , fixedHeight = Nothing
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
                , CssUtil.styleMaybe
                    Style.height
                    summary.fixedHeight
                ]
            , Attrs.spellcheck False
            , Attrs.value value
            ]

        conditionalAttributes : List (Attribute msg)
        conditionalAttributes =
            [ summary.onInput
                |> Maybe.map Events.onInput
            ]
                |> List.filterMap identity
    in
    Html.textarea
        (attributes ++ conditionalAttributes)
        []
