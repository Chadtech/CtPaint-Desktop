module View.Card exposing (view)

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style


view : List Style -> List (Html msg) -> Html msg
view styles =
    Grid.box
        (cardStyles :: styles)


cardStyles : Style
cardStyles =
    [ Style.outdent
    , Css.backgroundColor Colors.content1
    , Style.padding 1
    ]
        |> Css.batch
