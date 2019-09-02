module Route exposing
    ( Route(..)
    , about
    , drawings
    , fromUrl
    , goTo
    , goToAbout
    , goToDrawings
    , paintApp
    , paintAppFromDrawing
    , paintAppFromUrl
    , paintAppWithParams
    , toUrl
    )

import Data.Drawing as Drawing exposing (Drawing)
import Data.NavKey as NavKey exposing (NavKey)
import Route.About as About
import Route.Drawings as Drawings
import Route.PaintApp as PaintApp
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), (<?>), Parser, s)



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
    | About About.Route
    | Login
    | ResetPassword
    | Logout
    | Settings
    | Drawings Drawings.Route
    | InitDrawing



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
    , Url.map PaintApp (s "app" </> PaintApp.parser)
    , Url.map About (s "about" </> About.parser)
    , Url.map Login (s "login")
    , Url.map ResetPassword (s "resetpassword")
    , Url.map Logout (s "logout")
    , Url.map Settings (s "settings")
    , Url.map Drawings (s "drawings" </> Drawings.parser)
    , Url.map InitDrawing (s "init")

    --    , Url.map Register (s "register")
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
            "app" :: PaintApp.toUrlPieces subRoute

        Login ->
            [ "login" ]

        ResetPassword ->
            [ "resetpassword" ]

        Logout ->
            [ "logout" ]

        Settings ->
            [ "settings" ]

        Drawings subRoute ->
            "drawings" :: Drawings.toUrlPieces subRoute

        InitDrawing ->
            [ "init" ]

        About subRoute ->
            "about" :: About.toUrlPieces subRoute



--
--
--
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


goToAbout : NavKey -> About.Route -> Cmd msg
goToAbout key =
    goTo key << About


goToDrawings : NavKey -> Drawings.Route -> Cmd msg
goToDrawings key =
    goTo key << Drawings


about : Route
about =
    About About.Info


drawings : Route
drawings =
    Drawings Drawings.Landing


paintApp : Route
paintApp =
    PaintApp PaintApp.Landing


paintAppWithParams : PaintApp.Params -> Route
paintAppWithParams =
    PaintApp << PaintApp.WithParams


paintAppFromUrl : String -> Route
paintAppFromUrl =
    PaintApp << PaintApp.FromUrl << Url.percentEncode


paintAppFromDrawing : Drawing.PublicId -> Route
paintAppFromDrawing =
    PaintApp << PaintApp.FromDrawing
