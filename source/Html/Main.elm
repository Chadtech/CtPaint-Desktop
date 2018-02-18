module Html.Main
    exposing
        ( css
        , view
        , viewWithNav
        )

import Chadtech.Colors exposing (ignorable2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div)
import Html.CssHelpers
import Html.Custom
import Html.Variables
import Model exposing (Model)
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


viewWithNav : Model -> List (Html Msg) -> Html Msg
viewWithNav model children =
    div
        [ class [ Main ] ]
        [ Nav.view model
            |> Html.map NavMsg
        , div
            [ class [ Body ] ]
            children
        ]
