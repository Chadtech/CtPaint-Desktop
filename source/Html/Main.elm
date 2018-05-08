module Html.Main
    exposing
        ( css
        , view
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


{-|

    This module is kind of like a frame for the page views.
    The page views are rendered inside of a general body,
    that is underneath the nav bar. This module is for
    rendering the body, and the nav bar, and its given
    a bunch of page html to render inside the body.

-}



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
        |> minHeight


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


view : Model -> List (Html Msg) -> Html Msg
view model children =
    div
        [ class [ Main ] ]
        [ Nav.view model
            |> Html.map NavMsg
        , div
            [ class [ Body ] ]
            children
        ]
