module View.Card exposing
    ( errorDisplay
    , textRow
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Css.Animations as Animations
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Text as Text
import View.TextArea as TextArea


view : List Style -> List (Html msg) -> Html msg
view styles =
    Grid.box
        (cardStyles :: styles)


textRow : List Style -> String -> Html msg
textRow styles text =
    Grid.row
        styles
        [ Grid.column
            [ Style.padding 1 ]
            [ Text.fromString text ]
        ]


errorDisplay : String -> Html msg
errorDisplay error =
    Grid.row
        []
        [ Grid.column
            []
            [ TextArea.readOnly error
                |> TextArea.withHeight 8
                |> TextArea.toHtml
            ]
        ]


cardStyles : Style
cardStyles =
    [ Style.outdent
    , Css.backgroundColor Colors.content1
    , Style.padding 1
    , Css.property "animation-duration" "150ms"
    , [ ( 0, [ Animations.transform [ Css.scale 0 ] ] )
      , ( 100, [ Animations.transform [ Css.scale 1 ] ] )
      ]
        |> Animations.keyframes
        |> Css.animationName
    ]
        |> Css.batch
