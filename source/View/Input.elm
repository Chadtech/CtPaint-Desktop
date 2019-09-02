module View.Input exposing
    ( Input
    , Option
    , config
    , isPassword
    , onEnter
    , readOnly
    , toHtml
    , withAutocomplete
    , withPlaceholder
    )

import Chadtech.Colors as Colors
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Html as HtmlUtil
import Util.Maybe as MaybeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Input msg
    = Input { value : String } (List (Option msg))


type Option msg
    = Password
    | OnEnter msg
    | Autocomplete String
    | Placeholder String
    | OnInput (String -> msg)


type alias Summary msg =
    { password : Bool
    , onEnter : Maybe msg
    , autocomplete : Maybe String
    , placeholder : Maybe String
    , onInput : Maybe (String -> msg)
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withPlaceholder : String -> Input msg -> Input msg
withPlaceholder =
    addOption << Placeholder


isPassword : Input msg -> Input msg
isPassword =
    addOption Password


onEnter : msg -> Input msg -> Input msg
onEnter =
    addOption << OnEnter


withAutocomplete : String -> Input msg -> Input msg
withAutocomplete =
    addOption << Autocomplete



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option msg -> Input msg -> Input msg
addOption option (Input model options) =
    Input model (option :: options)


optionsToSummary : List (Option msg) -> Summary msg
optionsToSummary =
    let
        modifySummary : Option msg -> Summary msg -> Summary msg
        modifySummary option summary =
            case option of
                Password ->
                    { summary | password = True }

                OnEnter msg ->
                    { summary | onEnter = Just msg }

                Autocomplete autocomplete ->
                    { summary | autocomplete = Just autocomplete }

                Placeholder placeholder ->
                    { summary | placeholder = Just placeholder }

                OnInput msgCtor ->
                    { summary | onInput = Just msgCtor }
    in
    List.foldr
        modifySummary
        { onEnter = Nothing
        , password = False
        , autocomplete = Nothing
        , placeholder = Nothing
        , onInput = Nothing
        }


config : (String -> msg) -> String -> Input msg
config msgCtor value =
    Input
        { value = value }
        [ OnInput msgCtor ]


readOnly : String -> Input msg
readOnly value =
    Input { value = value } []


toHtml : Input msg -> Html msg
toHtml (Input { value } options) =
    let
        summary : Summary msg
        summary =
            optionsToSummary options

        baseAttrs : List (Attribute msg)
        baseAttrs =
            [ Attrs.css
                [ Style.pit
                , Style.height 5
                , Style.font
                , Style.noOutline
                , Css.color Colors.content4
                , Style.fontSmoothingNone
                , Style.padding 2
                , Style.fullWidth
                ]
            , Attrs.value value
            , Attrs.spellcheck False
            ]

        conditionalAttrs : List (Attribute msg)
        conditionalAttrs =
            [ MaybeUtil.fromBool
                summary.password
                (Attrs.type_ "password")
            , Maybe.map
                HtmlUtil.onEnter
                summary.onEnter
            , Maybe.map
                (Attrs.attribute "autocomplete")
                summary.autocomplete
            , Maybe.map
                Attrs.placeholder
                summary.placeholder
            , Maybe.map
                Events.onInput
                summary.onInput
            ]
                |> List.filterMap identity
    in
    Html.input
        (baseAttrs ++ conditionalAttrs)
        []
