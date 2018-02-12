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
import Route exposing (Route)
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    ()


type Msg
    = RouteClicked Route



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteClicked route ->
            model & Route.goTo route



-- STYLES --


type Class
    = Nav
    | Divider
    | Button
    | User
    | Offline


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
    , Css.class Offline
        [ float right
        , padding (px 8)
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
    [ button "draw" (RouteClicked Route.InitDrawing)
    , a [ class [ Divider ] ] []
    , button "home" (RouteClicked Route.Landing)
    , button "about" (RouteClicked Route.About)
    , button "contact" (RouteClicked Route.Contact)
    , button "pricing" (RouteClicked Route.Pricing)
    , button "road map" (RouteClicked Route.RoadMap)
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
            [ p
                [ class [ Offline ] ]
                [ Html.text "offline" ]
            ]

        User.LoggedOut ->
            [ userButton "register" (RouteClicked Route.Register)
            , userButton "log in" (RouteClicked Route.Login)
            ]

        User.LoggingIn ->
            []

        User.LoggedIn _ ->
            [ userButton "log out" (RouteClicked Route.Logout)
            , userButton "settings" (RouteClicked Route.Settings)
            ]


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
