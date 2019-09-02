module View.Card exposing
    ( errorDisplay
    , errorView
    , textRow
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Style
import Style.Animation
import View.CardHeader as CardHeader
import View.Text as Text
import View.TextArea as TextArea


view : List Style -> List (Html msg) -> Html msg
view styles =
    Grid.box
        (cardStyles :: styles)


errorView :
    { title : String
    , errorMessage : String
    , error : Maybe String
    }
    -> List (Html msg)
    -> Html msg
errorView { title, errorMessage, error } children =
    view
        []
        ([ CardHeader.config
            { title = title }
            |> CardHeader.toHtml
         , textRow [] errorMessage
         , error
            |> Maybe.map errorDisplay
            |> Maybe.withDefault (Html.text "")
         ]
            ++ children
        )


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
    , Style.Animation.popin
    ]
        |> Css.batch
