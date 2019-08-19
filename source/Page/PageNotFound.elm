module Page.PageNotFound exposing
    ( Msg
    , track
    , update
    , view
    )

import Css
import Data.Document exposing (Document)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Route
import Style
import View.Button as Button
import View.ButtonRow as ButtonRow
import View.Card as Card
import View.CardHeader as CardHeader
import View.SingleCardPage as SingleCardPage



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Msg
    = GoHomeClicked



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Document Msg
view =
    { title = Nothing
    , body =
        Card.view
            [ Style.width 9 ]
            [ CardHeader.config
                { title = "page not found" }
                |> CardHeader.toHtml
            , Card.textRow
                []
                "Sorry, something went wrong. This page does not exist."
            , ButtonRow.view
                [ Button.config
                    GoHomeClicked
                    "go home"
                ]
            ]
            |> SingleCardPage.view
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Cmd msg
update navKey msg =
    case msg of
        GoHomeClicked ->
            Route.goTo navKey Route.Landing


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        GoHomeClicked ->
            Tracking.event "go home clicked"
