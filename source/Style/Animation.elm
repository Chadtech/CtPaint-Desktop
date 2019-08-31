module Style.Animation exposing (popin)

import Css exposing (Style)
import Css.Animations as Animations


popin : Style
popin =
    [ Css.property "animation-duration" "150ms"
    , [ ( 0, [ Animations.transform [ Css.scale 0 ] ] )
      , ( 100, [ Animations.transform [ Css.scale 1 ] ] )
      ]
        |> Animations.keyframes
        |> Css.animationName
    ]
        |> Css.batch
