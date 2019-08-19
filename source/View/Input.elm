module View.Input exposing
    ( Input
    , Option
    , config
    , isPassword
    , onEnter
    , toHtml
    , withAutocomplete
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
    = Input
        { value : String
        , onInput : String -> msg
        }
        (List (Option msg))


type Option msg
    = Password
    | OnEnter msg
    | Autocomplete String


type alias Summary msg =
    { password : Bool
    , onEnter : Maybe msg
    , autocomplete : Maybe String
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


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
    in
    List.foldr
        modifySummary
        { onEnter = Nothing
        , password = False
        , autocomplete = Nothing
        }


config : (String -> msg) -> String -> Input msg
config msgCtor value =
    Input
        { value = value
        , onInput = msgCtor
        }
        []


toHtml : Input msg -> Html msg
toHtml (Input { value, onInput } options) =
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
            , Events.onInput onInput
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
            ]
                |> List.filterMap identity
    in
    Html.input
        (baseAttrs ++ conditionalAttrs)
        []
