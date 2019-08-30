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
        optionView : List Style -> Option -> Grid.Column Msg
        optionView extraStyles option =
            Grid.column
                [ Grid.columnShrink
                , Style.marginRight 2
                , Css.batch extraStyles
                ]
                [ Button.config
                    (NavBarOptionClicked option)
                    (Option.toLabel option)
                    |> Button.indent
                        (optionIsCurrentPage model option)
                    |> Button.toHtml
                ]

        userOptions : List (Grid.Column Msg)
        userOptions =
            case Model.getUser model of
                User.User ->
                    [ optionView [] Option.Login ]

                User.Account _ ->
                    [ optionView [] Option.Logout
                    , optionView [] Option.Account
                    ]
    in
    Grid.row
        [ Style.fullWidth
        , Css.backgroundColor Colors.content1
        , Style.padding 2
        , Style.borderBottom Colors.content0
        ]
        ([ optionView
            [ Style.marginRight 3 ]
            Option.Draw
         , Grid.column
            [ Style.verticalDivider
            , Grid.columnShrink
            , Style.marginRight 3
            , Style.height 5
            ]
            []
         , optionView [] Option.Title
         , optionView [] Option.About
         , optionView [] Option.Contact
         , Grid.column [] []
         ]
            ++ userOptions
        )


optionIsCurrentPage : Model -> Option -> Bool
optionIsCurrentPage model option =
    case ( model, option ) of
        ( Model.Splash _, Option.Title ) ->
            True

        ( Model.Home _, Option.Title ) ->
            True

        ( Model.About _, Option.About ) ->
            True

        ( Model.Login _, Option.Login ) ->
            True

        ( Model.Contact _, Option.Contact ) ->
            True

        ( Model.Settings _, Option.Account ) ->
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
