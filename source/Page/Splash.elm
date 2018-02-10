module Page.Splash
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, div, img, p, video)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom


-- TYPES --


type Msg
    = Noop



-- UPDATE --


update : Msg -> Cmd Msg
update Noop =
    Cmd.none



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
        , backgroundColor backgroundx2
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


msg : String
msg =
    """
    CtPaint is good pixel art software that runs in your internet browser.
    It has all the functionality of a classic paint program with cloud storage
    and a seamless connection to all the internets images. Its free and
    requires no installation.
    """


view : Taco -> List (Html Msg)
view taco =
    [ div
        [ class [ LogoContainer ] ]
        [ img
            [ class [ Logo ]
            , Attrs.src (taco.config.mountPath ++ "/splash-image.png")
            ]
            []
        ]
    , div
        [ class [ TextContainer ] ]
        [ p [] [ Html.text msg ] ]
    , div
        [ class [ ButtonsContainer ] ]
        [ a
            [ class [ Button ] ]
            [ Html.text "start drawing" ]
        , a
            [ class [ Button ] ]
            [ Html.text "learn more" ]
        ]
    , video
        [ class [ Video ]
        , Attrs.src (taco.config.mountPath ++ "/splash-video.mp4")
        , Attrs.autoplay True
        , Attrs.loop True
        ]
        []
    ]
