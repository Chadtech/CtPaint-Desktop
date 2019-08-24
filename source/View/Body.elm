module View.Body exposing
    ( Body
    , Option
    , singleColumnView
    , singleColumnWidth
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Body msg
    = Body (List Option) (List (Html msg))


type Option
    = SingleColumnWidth



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


singleColumnWidth : Body msg -> Body msg
singleColumnWidth =
    addOption SingleColumnWidth


addOption : Option -> Body msg -> Body msg
addOption option (Body options children) =
    Body (option :: options) children



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : List (Grid.Column msg) -> List (Html msg)
view children =
    [ Grid.row
        [ Css.backgroundColor Colors.content1
        , Style.fullWidth
        , Css.flex (Css.int 1)
        , Style.centerContent
        ]
        children
    ]


singleColumnView : List (Html msg) -> List (Html msg)
singleColumnView children =
    view
        [ Grid.column
            [ Style.width 10
            , Css.flex Css.none
            , Css.flexDirection Css.column
            ]
            children
        ]
