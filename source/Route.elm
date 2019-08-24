module Route exposing
    ( Route(..)
    , fromUrl
    , goTo
    , paintApp
    , paintAppFromDrawing
    , paintAppFromUrl
    , paintAppWithParams
    , toUrl
    )

import Data.Drawing exposing (Drawing)
import Data.NavKey as NavKey exposing (NavKey)
import Id exposing (Id)
import Route.PaintApp as PaintApp
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), (<?>), Parser)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


{-|

    Routes are a narrow list of the possible urls
    users of this application can visit.
    The Landing route is just "www.ctpaint.org".
    The login Route is "www.ctpaint.org/login".
    There isnt a Landing page however, the landing
    route goes to different pages depending on if
    the user is logged in. Conversely, there are
    pages that dont have routes, like the error
    page and the blank page.

-}
type Route
    = Landing
    | PaintApp PaintApp.Route
    | About
    | Login
    | ResetPassword
    | Logout
    | Settings



--    | InitDrawing
--    | Documentation
--    | Contact
--    | Pricing
--    | RoadMap
--    | Login
--    | Register
--    | Verify
-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


fromUrl : Url -> Result String Route
fromUrl url =
    case Url.parse parser url of
        Just route ->
            Ok route

        Nothing ->
            Err url.path


parser : Parser (Route -> a) a
parser =
    [ Url.map Landing Url.top
    , Url.map PaintApp PaintApp.parser
    , Url.map About (Url.s "about")
    , Url.map Login (Url.s "login")
    , Url.map ResetPassword (Url.s "resetpassword")
    , Url.map Logout (Url.s "logout")
    , Url.map Settings (Url.s "settings")

    --    , Url.map InitDrawing (s "init")
    --    , Url.map Documentation (s "documentation")
    --    , Url.map Contact (s "contact")
    --    , Url.map Pricing (s "pricing")
    --    , Url.map RoadMap (s "roadmap")
    --    , Url.map Register (s "register")
    --    , Url.map Settings (s "settings")
    --    , Url.map Verify (s "verify")
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

        PaintApp subRoute ->
            [ "app", PaintApp.toUrl subRoute ]

        About ->
            [ "about" ]

        Login ->
            [ "login" ]

        ResetPassword ->
            [ "resetpassword" ]

        Logout ->
            [ "logout" ]

        Settings ->
            [ "settings" ]



--        InitDrawing ->
--            [ "init" ]
--
--
--        Documentation ->
--            [ "documentation" ]
--
--        Contact ->
--            [ "contact" ]
--
--        Pricing ->
--            [ "pricing" ]
--
--        RoadMap ->
--            [ "roadmap" ]
--
--
--        Register ->
--            [ "register" ]
--
--
--
--        Verify ->
--            [ "verify" ]


goTo : NavKey -> Route -> Cmd msg
goTo key =
    NavKey.goTo key << toUrl


paintApp : Route
paintApp =
    PaintApp PaintApp.Landing


paintAppWithParams : PaintApp.Params -> Route
paintAppWithParams =
    PaintApp << PaintApp.WithParams


paintAppFromUrl : String -> Route
paintAppFromUrl =
    PaintApp << PaintApp.FromUrl << Url.percentEncode


paintAppFromDrawing : Id Drawing -> Route
paintAppFromDrawing =
    PaintApp << PaintApp.FromDrawing
