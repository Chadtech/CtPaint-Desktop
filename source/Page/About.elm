module Page.About
    exposing
        ( css
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Config as Config exposing (Config)
import Data.Taco exposing (Taco)
import Html exposing (Html, br, div, img, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom exposing (p_)


-- STYLES --


type Class
    = TextContainer
    | Logo
    | LogoContainer
    | Divider


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
view { config } =
    [ div
        [ class [ LogoContainer ] ]
        [ img
            [ class [ Logo ]
            , Attrs.src (Config.assetSrc config .logoSrc)
            ]
            []
        ]
    , textContent config
    ]


textContent : Config -> Html msg
textContent { buildNumber } =
    [ intro
    , personal
    , tech
    , thanks
    , String.join " "
        [ "This is build number"
        , toString buildNumber
        , "of this software"
        ]
    ]
        |> List.map p_
        |> List.intersperse break
        |> div [ class [ TextContainer ] ]


break : Html msg
break =
    br [] []


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


tech : String
tech =
    """
    It was made with the following technology: Elm, Elm-Css, Elm-Canvas,
    Browserify, Amazon Web Services, and Gulp.
    """


thanks : String
thanks =
    """
    Ive worked on this project for a long time, and so I have worked with
    a lot of different people during the course of this project. In chronological
    order, here are my thank yous. Thanks to Funkytek who caused me to get into
    JavaScript whereafter I began working on CtPaint. Thanks to Jack Hou, a contributor
    to Chromium, who added 'image rendering : pixelated' to Google Chromium,
    a development I followed closely and has been essential to the technology
    behind CtPaint. Thanks to the meet ups NodeAZ, VegasJS, QueensJS, and
    Elm Berlin for letting me talk about CtPaint. Thanks to my friend Jacob
    Rosenthal who was always there to talk to me about code, and initially proposed
    the idea of doing a kickstarter. Thanks to Ethan Hartman, Taylor Alexander, and
    Alex Rees, all of whom were marketers who had great feedback about kickstarter campaigns.
    Thanks to Patrick Gram, Bob Laudner, and David Urbanic, who  did a really good job
    helping me put together my kickstarter video.Thanks to everyone who contributed to
    the original kick starter even tho it wasnt successful. Thanks Sascha Naderer,
    Andreas Kullenberg, Jun, Bo, and Erik 'Kasumi' from the pixelation community,
    for either their thorough and knowledgeable opinions on pixel art software, as
    well as their time using the CtPaint alpha to provide feedback, or the pixel art
    they have contributed to this project.
    """
