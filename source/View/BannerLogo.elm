module View.BannerLogo exposing (view)

import Data.MountPath exposing (MountPath)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Image as Image


view : MountPath -> Html msg
view mountPath =
    Grid.row
        [ Style.pit
        , Style.marginVertical Style.i2
        ]
        [ Grid.column
            []
            [ Image.config
                (Image.logo mountPath)
                |> Image.withWidth 429
                |> Image.toHtml
            ]
        ]
