module Ui.Nav exposing
    ( Msg
    , track
    , update
    , view
    )

import Chadtech.Colors as Colors
import Css
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Model exposing (Model)
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
        optionView : Option -> Grid.Column Msg
        optionView option =
            Grid.column
                [ Grid.columnShrink ]
                [ Button.config
                    (NavBarOptionClicked option)
                    (Option.toLabel option)
                    |> Button.indent
                        (optionIsCurrentPage model option)
                    |> Button.asHalfWidth
                    |> Button.toHtml
                ]
    in
    Grid.row
        [ Style.fullWidth
        , Css.backgroundColor Colors.content1
        , Style.padding Style.i1
        , Style.borderBottom Colors.content0
        ]
        [ optionView Option.Draw
        , Grid.column
            [ Style.divider
            , Grid.columnShrink
            , Style.marginHorizontal Style.i2
            , Style.height Style.i4
            ]
            []
        , optionView Option.Home
        ]


optionIsCurrentPage : Model -> Option -> Bool
optionIsCurrentPage model option =
    case ( model, option ) of
        ( Model.Splash _, Option.Home ) ->
            True

        _ ->
            False



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Cmd Msg
update msg =
    case msg of
        NavBarOptionClicked option ->
            Cmd.none


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        NavBarOptionClicked option ->
            Tracking.event "nav bar option clicked"
                |> Tracking.withProp
                    "option"
                    (Option.encode option)
