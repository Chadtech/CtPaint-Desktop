module Route exposing
    ( Route(..)
    , fromUrl
    , goTo
    , toUrl
    )

import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey as NavKey exposing (NavKey)
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), Parser)



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
    | PaintApp
    | About



--    | InitDrawing
--    | About
--    | Documentation
--    | Contact
--    | Pricing
--    | RoadMap
--    | Settings
--    | Login
--    | ForgotPassword
--    | ResetPassword
--    | Logout
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
    , Url.map PaintApp (Url.s "app")
    , Url.map About (Url.s "about")

    --    , Url.map InitDrawing (s "init")
    --    , Url.map Documentation (s "documentation")
    --    , Url.map Contact (s "contact")
    --    , Url.map Pricing (s "pricing")
    --    , Url.map RoadMap (s "roadmap")
    --    , Url.map Login (s "login")
    --    , Url.map ForgotPassword (s "forgotpassword")
    --    , Url.map ResetPassword (s "resetpassword")
    --    , Url.map Logout (s "logout")
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

        PaintApp ->
            [ "app" ]

        About ->
            [ "about" ]



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
--        Settings ->
--            [ "settings" ]
--
--        Register ->
--            [ "register" ]
--
--        Login ->
--            [ "login" ]
--
--        ForgotPassword ->
--            [ "forgotpassword" ]
--
--        ResetPassword ->
--            [ "resetpassword" ]
--
--        Logout ->
--            [ "logout" ]
--
--        Verify ->
--            [ "verify" ]


goTo : NavKey -> Route -> Cmd msg
goTo key =
    NavKey.goTo key << toUrl
