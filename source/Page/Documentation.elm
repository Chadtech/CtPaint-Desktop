module Page.Documentation
    exposing
        ( Model
        , css
        , init
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Feature as Feature exposing (Feature)
import Data.Taco exposing (Taco)
import Helpers.Random
import Html exposing (Html, div, img, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom exposing (p_)
import Random.Pcg exposing (Seed)


-- TYPES --


type alias Model =
    List Feature


init : Seed -> ( Model, Seed )
init =
    Helpers.Random.shuffle Feature.all



-- STYLES --


type Class
    = TextContainer
    | Logo
    | LogoContainer
    | Divider
    | Feature
    | FeatureImageContainer
    | FeatureImage
    | Body


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
        , backgroundColor Ct.background2
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
        , backgroundColor Ct.background2
        , overflow hidden
        , float left
        , marginRight (px 8)
        ]
    , Css.class FeatureImage
        [ width (px (imageSize - 4)) ]
    , Css.class Body
        [ width (px 800)
        , display block
        , margin auto
        , overflow scroll
        ]
    ]
        |> namespace documentationNamespace
        |> stylesheet


documentationNamespace : String
documentationNamespace =
    Html.Custom.makeNamespace "Documentation"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace documentationNamespace


view : Taco -> Model -> List (Html msg)
view taco model =
    [ div
        [ class [ TextContainer ] ]
        [ p
            []
            [ Html.text documentationText ]
        ]
    , div
        [ class [ Divider ] ]
        []
    , div
        [ class [ Body ] ]
        (features taco model)
    ]


features : Taco -> Model -> List (Html msg)
features taco =
    List.map (feature taco)


feature : Taco -> Feature -> Html msg
feature { config } feature =
    div
        [ class [ Feature ] ]
        [ div
            [ class [ FeatureImageContainer ] ]
            [ img
                [ class [ FeatureImage ]
                , feature
                    |> Feature.imgUrl config
                    |> Attrs.src
                ]
                []
            ]
        , p_ feature.name
        , p_ feature.description
        ]


documentationText : String
documentationText =
    """
    Below is a list of all the features in CtPaint.
    """
