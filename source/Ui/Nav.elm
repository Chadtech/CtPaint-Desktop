module Ui.Nav exposing
    ( Msg
    , track
    , update
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Model exposing (Model)
import Route
import Style
import Ui.Nav.Option as Option exposing (Option)
import View.Button as Button



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Msg
    = NavBarOptionClicked Option



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    let
        optionView : List Style -> Option -> Grid.Column Msg
        optionView extraStyles option =
            Grid.column
                [ Grid.columnShrink
                , Style.marginRight Style.i1
                , Css.batch extraStyles
                ]
                [ Button.config
                    (NavBarOptionClicked option)
                    (Option.toLabel option)
                    |> Button.indent
                        (optionIsCurrentPage model option)
                    |> Button.toHtml
                ]
    in
    Grid.row
        [ Style.fullWidth
        , Css.backgroundColor Colors.content1
        , Style.padding Style.i1
        , Style.borderBottom Colors.content0
        ]
        [ optionView
            [ Style.marginRight Style.i2 ]
            Option.Draw
        , Grid.column
            [ Style.divider
            , Grid.columnShrink
            , Style.marginRight Style.i2
            , Style.height Style.i4
            ]
            []
        , optionView [] Option.Title
        , optionView [] Option.About
        , Grid.column [] []
        , optionView [] Option.Login
        ]


optionIsCurrentPage : Model -> Option -> Bool
optionIsCurrentPage model option =
    case ( model, option ) of
        ( Model.Splash _, Option.Title ) ->
            True

        ( Model.About _, Option.About ) ->
            True

        ( Model.Login _, Option.Login ) ->
            True

        _ ->
            False



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Cmd Msg
update navKey msg =
    case msg of
        NavBarOptionClicked option ->
            Route.goTo navKey (Option.toRoute option)


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        NavBarOptionClicked option ->
            Tracking.event "nav bar option clicked"
                |> Tracking.withProp
                    "option"
                    (Option.encode option)
