module View.ButtonRow exposing (view)

import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Button as Button exposing (Button)


view : List (Button msg) -> Html msg
view buttons =
    Grid.row
        [ Style.centerContent ]
        (List.map buttonColumn buttons)


buttonColumn : Button msg -> Grid.Column msg
buttonColumn button =
    Grid.column
        [ Grid.columnShrink ]
        [ Button.toHtml button ]
