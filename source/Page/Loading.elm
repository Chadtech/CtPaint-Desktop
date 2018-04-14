module Page.Loading exposing (..)

import Html exposing (Html, p)
import Html.Custom
import Page exposing (HoldUp(..))


view : HoldUp -> Html msg
view holdUp =
    Html.Custom.card []
        [ Html.Custom.header
            { text = "loading"
            , closability = Html.Custom.NotClosable
            }
        , Html.Custom.cardBody []
            [ p [] [ Html.text (loadingText holdUp) ]
            , Html.Custom.spinner
            ]
        ]


loadingText : HoldUp -> String
loadingText holdUp =
    case holdUp of
        UserAttributes ->
            "loading user"
