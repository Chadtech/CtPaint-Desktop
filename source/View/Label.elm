module View.Label exposing (view)

import Css exposing (Style)
import Html.Grid as Grid
import Style
import View.Text as Text


view : String -> List Style -> Grid.Column msg
view label styles =
    Grid.column
        [ Css.batch styles
        , Css.flexDirection Css.column
        , Style.centerContent
        ]
        [ Text.fromString label ]
