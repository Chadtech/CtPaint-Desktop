module View.SingleCardPage exposing (view)

import Css
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style


view : Html msg -> List (Html msg)
view card =
    [ Grid.row
        [ Css.flex (Css.int 1)
        , Style.centerContent
        ]
        [ Grid.column
            [ Grid.columnShrink
            , Style.centerContent
            , Css.flexDirection Css.column
            ]
            [ card ]
        ]
    ]
