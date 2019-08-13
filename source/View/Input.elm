module View.Input exposing
    ( Input
    , Option
    , config
    , isPassword
    , toHtml
    )

import Chadtech.Colors as Colors
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
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


type alias Summary msg =
    { password : Bool
    , unit : Maybe msg
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


isPassword : Input msg -> Input msg
isPassword =
    addOption Password



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
    in
    List.foldr
        modifySummary
        { unit = Nothing
        , password = False
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
            ]
                |> List.filterMap identity
    in
    Html.input
        (baseAttrs ++ conditionalAttrs)
        []
