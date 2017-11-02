module Page.Loading exposing (..)

import Html exposing (Html, a, br, div, p, text)
import Html.Spinner exposing (spinner)
import Page exposing (HoldUp(..))
import Styles exposing (Classes(..))


{ class } =
    Styles.helpers


view : HoldUp -> Html msg
view holdUp =
    div
        [ class [ Card, Solitary ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "loading" ] ]
        , div
            [ class [ Body ] ]
            [ p
                [ class [ HasBottomMargin, TextAlignCenter ] ]
                [ text (loadingText holdUp) ]
            , spinner
            ]
        ]


loadingText : HoldUp -> String
loadingText holdUp =
    case holdUp of
        UserAttributes ->
            "loading user"
