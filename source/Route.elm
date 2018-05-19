module Route
    exposing
        ( Route(..)
        , fromLocation
        , goTo
        , toUrl
        )

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, s)


-- TYPES --


{-|

    Routes, not to be confused with Pages.

    Routes are a narrow list of possible urls.
    The Landing route is just "www.ctpaint.org".
    The login Route is "www.ctpaint.org/login".
    There isnt a Landing page however, the landing
    route goes to different pages depending on if
    the user is logged in. There are pages that
    dont have routes, like the error page and the
    blank page.

-}
type Route
    = Landing
    | InitDrawing
    | About
    | Documentation
    | Contact
    | Pricing
    | RoadMap
    | Settings
    | Login
    | ForgotPassword
    | ResetPassword
    | Logout
    | Register
    | Verify
    | AllowanceExceeded



-- HELPERS --


fromLocation : Location -> Result String Route
fromLocation location =
    case Url.parsePath route location of
        Just route ->
            Ok route

        Nothing ->
            (location.origin ++ location.pathname)
                |> Err


route : Parser (Route -> a) a
route =
    [ Url.map Landing (s "")
    , Url.map InitDrawing (s "init")
    , Url.map About (s "about")
    , Url.map Documentation (s "documentation")
    , Url.map Contact (s "contact")
    , Url.map Pricing (s "pricing")
    , Url.map RoadMap (s "roadmap")
    , Url.map Login (s "login")
    , Url.map ForgotPassword (s "forgotpassword")
    , Url.map ResetPassword (s "resetpassword")
    , Url.map Logout (s "logout")
    , Url.map Register (s "register")
    , Url.map Settings (s "settings")
    , Url.map Verify (s "verify")
    , Url.map AllowanceExceeded (s "allowanceexceeded")
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

        Documentation ->
            [ "documentation" ]

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

        ForgotPassword ->
            [ "forgotpassword" ]

        ResetPassword ->
            [ "resetpassword" ]

        Logout ->
            [ "logout" ]

        Verify ->
            [ "verify" ]

        AllowanceExceeded ->
            [ "allowanceexceeded" ]


goTo : Route -> Cmd msg
goTo =
    toUrl >> Navigation.newUrl
