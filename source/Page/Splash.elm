module Page.Splash exposing
    ( Msg
    , track
    , update
    , view
    )

import Css
import Data.Document exposing (Document)
import Data.MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Route
import Style
import View.BannerLogo as BannerLogo
import View.Body as Body
import View.Button as Button
import View.Text as Text
import View.Video as Video



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Msg
    = LearnMoreClicked
    | DrawClicked



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : MountPath -> Document Msg
view mountPath =
    { title = Nothing
    , body = viewBody mountPath
    }


viewBody : MountPath -> List (Html Msg)
viewBody mountPath =
    [ Body.config
        [ BannerLogo.view mountPath
        , Grid.row
            [ Style.marginBottom Style.i2 ]
            [ Grid.column
                []
                [ Text.fromString splashMsg ]
            ]
        , Grid.row
            [ Css.justifyContent Css.spaceAround ]
            [ button
                LearnMoreClicked
                "learn more"
            , button
                DrawClicked
                "start drawing"
            ]
        , Grid.row
            [ Style.indent
            , Style.marginTop Style.i2
            ]
            [ Grid.column
                []
                [ Video.config
                    (Video.splash mountPath)
                    |> Video.asFullWidth
                    |> Video.toHtml
                ]
            ]
        ]
        |> Body.singleColumnWidth
        |> Body.toHtml
    ]


button : Msg -> String -> Grid.Column Msg
button msg label =
    Grid.column
        [ Grid.columnShrink ]
        [ Button.config msg label
            |> Button.asDoubleWidth
            |> Button.makeTaller True
            |> Button.toHtml
        ]


splashMsg : String
splashMsg =
    """
    CtPaint is good pixel art software that runs in your internet browser.
    It has all the functionality of a classic paint program with cloud storage
    and a seamless connection to all the internets images. Its free and
    requires no installation.
    """



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Cmd Msg
update key msg =
    case msg of
        LearnMoreClicked ->
            Route.goTo key Route.About

        DrawClicked ->
            Route.goTo key Route.PaintApp


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        LearnMoreClicked ->
            Tracking.event "learn-more click"

        DrawClicked ->
            Tracking.event "draw click"
