module View.Input exposing
    ( Input
    , Option
    , config
    , toHtml
    )

import Chadtech.Colors as Colors
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style



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
    = Option


type alias Summary msg =
    { unit : Maybe msg }



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
                Option ->
                    summary
    in
    List.foldr
        modifySummary
        { unit = Nothing }


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
    in
    Html.input
        [ Attrs.css
            [ Style.pit
            , Style.height Style.i4
            , Style.font
            , Style.noOutline
            , Css.color Colors.content4
            , Style.fontSmoothingNone
            , Style.padding Style.i1
            , Style.fullWidth
            ]
        , Attrs.value value
        , Attrs.spellcheck False
        , Events.onInput onInput
        ]
        []
