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
import Data.User as User
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
        optionViewWithStyles : List Style -> Option -> Grid.Column Msg
        optionViewWithStyles styles option =
            Grid.column
                (Grid.columnShrink :: styles)
                [ Button.config
                    (NavBarOptionClicked option)
                    (Option.toLabel option)
                    |> Button.indent (optionIsCurrentPage model option)
                    |> Button.asDoubleWidthIf (option == Option.NewDrawing)
                    |> Button.toHtml
                ]

        optionView : Option -> Grid.Column Msg
        optionView =
            optionViewWithStyles [ Style.buttonMarginLeft ]

        firstOptionView : Option -> Grid.Column Msg
        firstOptionView =
            optionViewWithStyles [ Style.buttonMarginRight ]

        userOptions : List (Grid.Column Msg)
        userOptions =
            case Model.getUser model of
                User.User ->
                    [ optionView Option.Login ]

                User.Account _ ->
                    [ optionView Option.Logout
                    , optionView Option.Account
                    ]

        drawingsOption : List (Grid.Column Msg)
        drawingsOption =
            case Model.getUser model of
                User.User ->
                    []

                User.Account _ ->
                    [ optionView Option.Drawings ]
    in
    Grid.row
        [ Style.fullWidth
        , Css.backgroundColor Colors.content1
        , Style.padding 1
        , Style.borderBottom Colors.content0
        ]
        ([ [ firstOptionView Option.NewDrawing ]
         , drawingsOption
         , [ optionView Option.About
           , Grid.column [] []
           ]
         , userOptions
         ]
            |> List.concat
        )


optionIsCurrentPage : Model -> Option -> Bool
optionIsCurrentPage model option =
    Model.toRoute model == Just (Option.toRoute option)



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
