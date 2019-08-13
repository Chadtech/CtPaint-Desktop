module View.CardHeader exposing
    ( CardHeader
    , Option
    , config
    ,  toHtml
       --    , withCloseButton

    )

import Chadtech.Colors as Colors
import Css
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type CardHeader msg
    = CardHeader { title : String } (List (Option msg))


type Option msg
    = CloseButton msg


type alias Summary msg =
    { closeButton : Maybe msg }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


withCloseButton : { onClick : msg } -> CardHeader msg -> CardHeader msg
withCloseButton { onClick } =
    addOption (CloseButton onClick)



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option msg -> CardHeader msg -> CardHeader msg
addOption option (CardHeader model options) =
    CardHeader model (option :: options)


optionsToSummary : List (Option msg) -> Summary msg
optionsToSummary =
    let
        modifySummary : Option msg -> Summary msg -> Summary msg
        modifySummary option summary =
            case option of
                CloseButton msg ->
                    { summary | closeButton = Just msg }
    in
    List.foldr
        modifySummary
        { closeButton = Nothing }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : { title : String } -> CardHeader msg
config model =
    CardHeader model []


toHtml : CardHeader msg -> Html msg
toHtml (CardHeader model options) =
    let
        summary : Summary msg
        summary =
            optionsToSummary options
    in
    Grid.row
        [ Css.backgroundColor Colors.content4
        , Style.marginBottom 2
        ]
        [ Grid.column
            [ Style.padding 2 ]
            [ Text.withStyles
                [ Css.color Colors.content1 ]
                model.title
            ]
        ]
