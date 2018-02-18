module Nav
    exposing
        ( Msg
        , css
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
import Model exposing (Model)
import Page exposing (Page)
import Route exposing (Route)


-- TYPES --


type Msg
    = RouteClicked Route



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        RouteClicked route ->
            Route.goTo route



-- STYLES --


type Class
    = Nav
    | Divider
    | Button
    | User
    | Offline
    | Selected


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
        , withClass Selected
            Html.Custom.indent
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


{ classList, class } =
    Html.CssHelpers.withNamespace navNamespace


view : Model -> Html Msg
view { page, taco } =
    let
        button_ =
            button page
    in
    [ button_
        { label = "draw"
        , route = Route.InitDrawing
        }
    , a [ class [ Divider ] ] []
    , button_
        { label = "home"
        , route = Route.Landing
        }
    , button_
        { label = "about"
        , route = Route.About
        }
    , button_
        { label = "documentation"
        , route = Route.Documentation
        }
    , button_
        { label = "contact"
        , route = Route.Contact
        }
    , button_
        { label = "pricing"
        , route = Route.Pricing
        }
    , button_
        { label = "road map"
        , route = Route.RoadMap
        }
    ]
        |> mixinUserButtons taco
        |> div [ class [ Nav ] ]


isSelected : Page -> Route -> Bool
isSelected page route =
    case ( page, route ) of
        ( Page.Home _, Route.Landing ) ->
            True

        ( Page.About, Route.About ) ->
            True

        ( Page.Documentation, Route.Documentation ) ->
            True

        ( Page.Contact _, Route.Contact ) ->
            True

        ( Page.Pricing, Route.Pricing ) ->
            True

        ( Page.RoadMap _, Route.RoadMap ) ->
            True

        ( Page.Settings _, Route.Settings ) ->
            True

        ( Page.Splash, Route.Landing ) ->
            True

        ( Page.Offline, Route.Landing ) ->
            True

        _ ->
            False


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


type alias ButtonModel =
    { label : String
    , route : Route
    }


button : Page -> ButtonModel -> Html Msg
button page { label, route } =
    a
        [ classList
            [ ( Button, True )
            , ( Selected, isSelected page route )
            ]
        , onClick (RouteClicked route)
        ]
        [ Html.text label ]
