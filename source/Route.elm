module Route exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, s)


type Route
    = Landing
    | InitDrawing
    | About
    | Contact
    | Pricing
    | RoadMap
    | Settings
    | Login
    | Logout
    | Register
    | Verify String String


fromLocation : Location -> Maybe Route
fromLocation =
    Url.parsePath route


route : Parser (Route -> a) a
route =
    [ Url.map Landing (s "")
    , Url.map InitDrawing (s "init")
    , Url.map About (s "about")
    , Url.map Contact (s "contact")
    , Url.map Pricing (s "pricing")
    , Url.map RoadMap (s "roadmap")
    , Url.map Login (s "login")
    , Url.map Logout (s "logout")
    , Url.map Register (s "register")
    , Url.map Settings (s "settings")
    , Url.map Verify (s "verify" </> Url.string </> Url.string)
    ]
        |> Url.oneOf


toUrl : Route -> String
toUrl route =
    "/" ++ String.join "/" (toPieces route)


toPieces : Route -> List String
toPieces route =
    case route of
        Landing ->
            []

        InitDrawing ->
            [ "init" ]

        About ->
            [ "about" ]

        Contact ->
            [ "contact" ]

        Pricing ->
            [ "pricing" ]

        RoadMap ->
            [ "roadmap" ]

        Settings ->
            [ "settings" ]

        Register ->
            [ "register" ]

        Login ->
            [ "login" ]

        Logout ->
            [ "logout" ]

        Verify email code ->
            [ "verify", email, code ]


goTo : Route -> Cmd msg
goTo =
    toUrl >> Navigation.newUrl
