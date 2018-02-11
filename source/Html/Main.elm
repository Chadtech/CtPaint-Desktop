module Html.Main
    exposing
        ( css
        , view
        , viewWithNav
        )

import Chadtech.Colors exposing (ignorable2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, div)
import Html.CssHelpers
import Html.Custom
import Html.Variables
import Msg exposing (Msg(NavMsg))
import Nav


-- STYLES --


type Class
    = Main
    | Body


bodyHeight : Style
bodyHeight =
    let
        nonBodyHeight =
            Html.Variables.navHeight + 2 + 8
    in
    calc (pct 100) minus (px nonBodyHeight)
        |> height


css : Stylesheet
css =
    [ Css.class Body
        [ backgroundColor ignorable2
        , width (pct 100)
        , bodyHeight
        , position relative
        , paddingTop (px 8)
        ]
    , Css.class Main
        [ width (pct 100)
        , height (pct 100)
        ]
    ]
        |> namespace mainNamespace
        |> stylesheet


mainNamespace : String
mainNamespace =
    Html.Custom.makeNamespace "Main"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace mainNamespace


view : List (Html msg) -> Html msg
view =
    div
        [ class [ Main ] ]


viewWithNav : Taco -> Nav.Model -> List (Html Msg) -> Html Msg
viewWithNav taco navModel children =
    div
        [ class [ Main ] ]
        [ Html.map NavMsg (Nav.view taco navModel)
        , div
            [ class [ Body ] ]
            children
        ]
