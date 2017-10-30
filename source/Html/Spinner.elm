module Html.Spinner exposing (spinner)

import Html exposing (Html, div)
import Html.Attributes
import Styles exposing (Classes(SpinnerContainer), helpers)


spinner : Html msg
spinner =
    div
        [ helpers.class [ SpinnerContainer ] ]
        [ div
            [ Html.Attributes.class "spinner" ]
            []
        ]
