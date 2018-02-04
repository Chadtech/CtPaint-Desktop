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
import Html.Nav as Nav
import Msg exposing (Msg(NavMsg))


-- STYLES --


type Class
    = Main
    | Body


css : Stylesheet
css =
    [ Css.class Body
        [ backgroundColor ignorable2
        , width (pct 100)
        , height
            (calc (pct 100) minus (px Html.Custom.navHeight))
        , top (px Html.Custom.navHeight)
        , left (px 0)
        , position absolute
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


viewWithNav : Taco -> List (Html Msg) -> Html Msg
viewWithNav taco children =
    div
        [ class [ Main ] ]
        [ Html.map NavMsg (Nav.view taco)
        , div
            [ class [ Body ] ]
            children
        ]
