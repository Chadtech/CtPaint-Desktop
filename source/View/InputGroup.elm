module View.InputGroup exposing (InputGroup(..), Model, Option(..), Summary, config, optionsToSummary, text, toHtml, withDoubleWidth, withError, withStyles)

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Style
import View.Input as Input exposing (Input)
import View.Label as Label
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type InputGroup msg
    = InputGroup (Model msg) (List Option)


type alias Model msg =
    { label : String
    , input : List (Html msg)
    }


type Option
    = Error (Maybe String)
    | ExtraStyles (List Style)
    | DoubleWidth


type alias Summary =
    { error : Maybe String
    , styles : List Style
    , doubleWidth : Bool
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withDoubleWidth : InputGroup msg -> InputGroup msg
withDoubleWidth =
    addOption DoubleWidth


withError : Maybe String -> InputGroup msg -> InputGroup msg
withError =
    addOption << Error


withStyles : List Style -> InputGroup msg -> InputGroup msg
withStyles =
    addOption << ExtraStyles



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option -> InputGroup msg -> InputGroup msg
addOption option (InputGroup model options) =
    InputGroup model (option :: options)


optionsToSummary : List Option -> Summary
optionsToSummary =
    let
        modifySummary : Option -> Summary -> Summary
        modifySummary option summary =
            case option of
                Error maybeError ->
                    { summary | error = maybeError }

                ExtraStyles styles ->
                    { summary | styles = styles ++ summary.styles }

                DoubleWidth ->
                    { summary | doubleWidth = True }
    in
    List.foldr
        modifySummary
        { error = Nothing
        , styles = []
        , doubleWidth = False
        }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : Model msg -> InputGroup msg
config model =
    InputGroup model []


text :
    { label : String
    , input : Input msg
    }
    -> InputGroup msg
text { label, input } =
    config
        { label = label
        , input = [ Input.toHtml input ]
        }


toHtml : InputGroup msg -> Html msg
toHtml (InputGroup { label, input } options) =
    let
        summary : Summary
        summary =
            optionsToSummary options

        width : Int
        width =
            if summary.doubleWidth then
                8

            else
                7
    in
    Grid.box
        [ Css.display Css.block
        , Css.batch summary.styles
        ]
        [ Grid.row
            []
            [ Label.view
                label
                [ Style.paddingLeft 1
                , Grid.exactWidthColumn
                    (Style.sizePx width)
                ]
            , Grid.column
                [ Css.flexDirection Css.column ]
                input
            ]
        , errorView summary.error
        ]


errorView : Maybe String -> Html msg
errorView maybeError =
    case maybeError of
        Just error ->
            Grid.row
                [ Css.backgroundColor Colors.problem0 ]
                [ Grid.column
                    [ Style.centerContent
                    , Css.flexDirection Css.column
                    , Style.padding 1
                    ]
                    [ Text.fromString error ]
                ]

        Nothing ->
            Html.text ""
