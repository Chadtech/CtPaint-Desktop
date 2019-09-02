module View.BannerLogo exposing (view)

import Css exposing (Style)
import Data.MountPath exposing (MountPath)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Image as Image


view : List Style -> MountPath -> Html msg
view styles mountPath =
    Grid.row
        (Style.pit :: styles)
        [ Grid.column
            []
            [ Image.config
                (Image.logo mountPath)
                |> Image.withWidth 429
                |> Image.toHtml
            ]
        ]
