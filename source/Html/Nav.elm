module Html.Nav
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Chadtech.Colors exposing (ignorable2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Html exposing (Html, a, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Html.Variables
import Route


-- TYPES --


type Msg
    = HomeClicked
    | LoginClicked
    | LogoutClicked
    | RegisterClicked



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        HomeClicked ->
            Route.goTo Route.Home

        LoginClicked ->
            Route.goTo Route.Login

        LogoutClicked ->
            Route.goTo Route.Logout

        RegisterClicked ->
            Route.goTo Route.Register



-- STYLES --


type Class
    = Nav
    | Button
    | User


css : Stylesheet
css =
    [ Css.class Nav
        [ height (px Html.Variables.navHeight)
        , backgroundColor ignorable2
        , padding (px 2)
        ]
    , Css.class Button
        [ Css.withClass User
            [ float right ]
        ]
    ]
        |> namespace navNamespace
        |> stylesheet


navNamespace : String
navNamespace =
    Html.Custom.makeNamespace "Nav"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace navNamespace


view : Taco -> Html Msg
view taco =
    [ button "home" HomeClicked ]
        |> mixinUserButtons taco
        |> div [ class [ Nav ] ]


mixinUserButtons : Taco -> List (Html Msg) -> List (Html Msg)
mixinUserButtons taco children =
    children ++ userButtons taco


userButtons : Taco -> List (Html Msg)
userButtons taco =
    case taco.user of
        User.Offline ->
            [ p [] [ Html.text "offline" ] ]

        User.LoggedOut ->
            [ userButton "register" RegisterClicked
            , userButton "log in" LoginClicked
            ]

        User.LoggingIn ->
            []

        User.LoggedIn _ ->
            [ userButton "log out" LogoutClicked ]


userButton : String -> Msg -> Html Msg
userButton label clickMsg =
    a
        [ class [ Button, User ]
        , onClick clickMsg
        ]
        [ Html.text label ]


button : String -> Msg -> Html Msg
button label clickMsg =
    a
        [ class [ Button ]
        , onClick clickMsg
        ]
        [ Html.text label ]
