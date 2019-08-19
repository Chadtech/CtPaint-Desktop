module View.Spinner exposing
    ( row
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (..)
import Css.Animations as Animations
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style


row : Html msg
row =
    Grid.row
        [ Style.centerContent ]
        [ Grid.column
            [ Grid.columnShrink ]
            [ view ]
        ]


view : Html msg
view =
    Grid.box
        [ Style.pit
        , Style.width 8
        , Style.height 5
        , Style.relative
        , Style.noOverflow
        ]
        [ Grid.box
            [ property "animation-duration" "1000ms"
            , property "animation-iteration-count" "infinite"
            , property "animation-timing-function" "linear"
            , [ left
                    0
                    ("-" ++ Style.pxStr 7)
              , left
                    100
                    (Style.pxStr 8)
              ]
                |> Animations.keyframes
                |> animationName
            , Style.width 6
            , Style.height 5
            , top (px 0)
            , position absolute
            , Css.backgroundColor Colors.content4
            ]
            []
        ]


left : Int -> String -> ( Int, List Animations.Property )
left percent pxs =
    ( percent, [ Animations.property "left" pxs ] )
