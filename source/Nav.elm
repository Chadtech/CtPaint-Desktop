module Nav
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors
    exposing
        ( ignorable1
        , ignorable2
        , ignorable3
        )
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
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    ()


type Msg
    = HomeClicked
    | AboutClicked
    | ContactClicked
    | PricingClicked
    | LoginClicked
    | LogoutClicked
    | RegisterClicked
    | DrawClicked



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DrawClicked ->
            model & Route.goTo Route.InitDrawing

        HomeClicked ->
            model & Route.goTo Route.Landing

        AboutClicked ->
            model & Route.goTo Route.About

        ContactClicked ->
            model & Route.goTo Route.Contact

        PricingClicked ->
            model & Route.goTo Route.Pricing

        LoginClicked ->
            model & Route.goTo Route.Login

        LogoutClicked ->
            model & Route.goTo Route.Logout

        RegisterClicked ->
            model & Route.goTo Route.Register



-- STYLES --


type Class
    = Nav
    | Divider
    | Button
    | User


css : Stylesheet
css =
    [ Css.class Nav
        [ height (px Html.Variables.navHeight)
        , backgroundColor ignorable2
        , padding (px 2)
        , borderBottom3 (px 2) solid ignorable3
        ]
    , Css.class Divider
        [ borderLeft3 (px 2) solid ignorable3
        , borderRight3 (px 2) solid ignorable1
        , height (px 32)
        , width zero
        , marginLeft (px 8)
        , marginRight (px 8)
        , paddingLeft zero
        , paddingRight zero
        , display inline
        ]
    , Css.class Button
        [ Css.withClass User
            [ float right ]
        , marginLeft (px 2)
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


view : Taco -> Model -> Html Msg
view taco model =
    [ button "draw" DrawClicked
    , a [ class [ Divider ] ] []
    , button "home" HomeClicked
    , button "about" AboutClicked
    , button "contact" ContactClicked
    , button "pricing" PricingClicked
    ]
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
