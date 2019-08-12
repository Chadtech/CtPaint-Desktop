module Page.Spasdasdasdalash exposing
    ( Msg
    , css
    , track
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Data.Config as Config
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Html exposing (Html, a, div, img, p, video)
import Html.Attributes as Attrs
import Html.Events exposing (onClick)
import Ports exposing (JsMsg)



-- TYPES --


type Msg
    = LearnMoreClicked
    | DrawClicked



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        LearnMoreClicked ->
            Route.goTo About

        DrawClicked ->
            Ports.send OpenPaintApp



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        LearnMoreClicked ->
            Tracking.noProps "learn-more click"

        DrawClicked ->
            Tracking.noProps "draw click"



-- STYLES --


type Class
    = Logo
    | LogoContainer
    | Video
    | TextContainer
    | ButtonsContainer
    | Button


css : Stylesheet
css =
    [ Css.class Logo
        [ margin auto
        , display block
        , width (px 429)
        ]
    , (Css.class LogoContainer << List.append Html.Custom.indent)
        [ margin auto
        , display block
        , width (px 800)
        , backgroundColor Ct.background2
        , marginBottom (px 8)
        ]
    , (Css.class Video << List.append Html.Custom.indent)
        [ margin auto
        , display block
        , width (px 800)
        ]
    , Css.class TextContainer
        [ width (px 800)
        , display block
        , margin auto
        , marginBottom (px 8)
        ]
    , Css.class ButtonsContainer
        [ width (px 800)
        , displayFlex
        , margin auto
        , marginBottom (px 8)
        , justifyContent spaceAround
        ]
    , Css.class Button
        [ padding4 (px 16) (px 32) (px 16) (px 32) ]
    ]
        |> namespace splashNamespace
        |> stylesheet


splashNamespace : String
splashNamespace =
    Html.Custom.makeNamespace "Splash"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace splashNamespace


view : Taco -> List (Html Msg)
view { config } =
    [ div
        [ class [ LogoContainer ] ]
        [ img
            [ class [ Logo ]
            , Attrs.src (Config.assetSrc config .logoSrc)
            ]
            []
        ]
    , div
        [ class [ TextContainer ] ]
        [ p [] [ Html.text msg ] ]
    , div
        [ class [ ButtonsContainer ] ]
        [ a
            [ class [ Button ]
            , onClick DrawClicked
            ]
            [ Html.text "start drawing" ]
        , a
            [ class [ Button ]
            , onClick LearnMoreClicked
            ]
            [ Html.text "learn more" ]
        ]
    , video
        [ class [ Video ]
        , Attrs.src (Config.assetSrc config .videoSrc)
        , Attrs.autoplay True
        , Attrs.loop True
        ]
        []
    ]
