module Page.About exposing (view)

import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.Document exposing (Document)
import Data.MountPath exposing (MountPath)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.BannerLogo as BannerLogo
import View.Body as Body
import View.Text as Text



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : BuildNumber -> MountPath -> Document msg
view buildNumber mountPath =
    { title = Just "about"
    , body =
        [ Body.config
            (BannerLogo.view mountPath :: textRows buildNumber)
            |> Body.singleColumnWidth
            |> Body.toHtml
        ]
    }


textRows : BuildNumber -> List (Html msg)
textRows buildNumber =
    let
        paragraphView : String -> Html msg
        paragraphView str =
            Grid.row
                [ Style.marginBottom 4 ]
                [ Grid.column
                    []
                    [ Text.fromString str ]
                ]
    in
    [ intro
    , personal
    , tech
    , thanks
    , String.join " "
        [ "This is build number"
        , BuildNumber.toString buildNumber
        , "of this software"
        ]
    ]
        |> List.map paragraphView


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
    helping me put together my kickstarter video. Thanks to everyone who contributed to
    the original kick starter even tho it wasnt successful. Thanks Sascha Naderer,
    Andreas Kullenberg, Jun, Bo, and Erik 'Kasumi' from the pixelation community,
    for either their thorough and knowledgeable opinions on pixel art software, as
    well as their time using the CtPaint alpha to provide feedback, or the pixel art
    they have contributed to this project.
    """
