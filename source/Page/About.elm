module Page.About
    exposing
        ( css
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Config as Config
import Data.Taco exposing (Taco)
import Html exposing (Html, br, div, img, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom


-- STYLES --


type Class
    = TextContainer
    | Logo
    | LogoContainer
    | Divider
    | Feature
    | FeatureImageContainer
    | FeatureImage


imageSize : Float
imageSize =
    150


css : Stylesheet
css =
    [ Css.class TextContainer
        [ width (px 800)
        , display block
        , margin auto
        , marginBottom (px 8)
        ]
    , Css.class Logo
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
    , (Css.class Divider << List.append Html.Custom.indent)
        [ width (px 800)
        , margin auto
        , display block
        , marginBottom (px 8)
        ]
    , Css.class Feature
        [ width (px 800)
        , margin auto
        , display table
        , marginBottom (px 8)
        , children
            [ Css.Elements.p
                [ marginBottom (px 8) ]
            ]
        ]
    , (Css.class FeatureImageContainer << List.append Html.Custom.indent)
        [ width (px (imageSize - 4))
        , height (px (imageSize - 4))
        , backgroundColor backgroundx2
        , overflow hidden
        , float left
        , marginRight (px 8)
        ]
    , Css.class FeatureImage
        [ width (px (imageSize - 4)) ]
    ]
        |> namespace aboutNamespace
        |> stylesheet


aboutNamespace : String
aboutNamespace =
    Html.Custom.makeNamespace "About"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace aboutNamespace


view : Taco -> List (Html msg)
view taco =
    topPart taco ++ features taco


topPart : Taco -> List (Html msg)
topPart { config } =
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
        [ p
            []
            [ Html.text intro ]
        , br [] []
        , p
            []
            [ Html.text personal ]
        ]
    , div
        [ class [ Divider ] ]
        []
    , div
        [ class [ TextContainer ] ]
        [ p
            []
            [ Html.text "feature list" ]
        ]
    ]


features : Taco -> List (Html msg)
features taco =
    [ feature
        "Open stuff"
        "Opening stuff is great"
        ""
    , feature
        "Save stuff too"
        "I love saving stuff"
        ""
    ]


feature : String -> String -> String -> Html msg
feature title words url =
    div
        [ class [ Feature ] ]
        [ div
            [ class [ FeatureImageContainer ] ]
            [ img
                [ class [ FeatureImage ]
                , Attrs.src url
                ]
                []
            ]
        , p
            []
            [ Html.text title ]
        , p
            []
            [ Html.text words ]
        ]


intro : String
intro =
    """
    CtPaint is good paint software that runs in your web browser.
    Its broadly suited for drawing pixel art, drawing memes, or just
    making a quick practical drawings like diagrams or maps. Its also
    embedded in the internet, so its super easy to edit any image
    already on the internet, or share your drawings via a url.
    """


personal : String
personal =
    """
    It was made by one guy named "Chadtech" over the course of two years
    in his free time.
    """
