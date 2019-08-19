module Route exposing
    ( Route(..)
    , fromUrl
    , goTo
    , toUrl
    )

import Data.BackgroundColor as BackgroundColor exposing (BackgroundColor)
import Data.Drawing exposing (Drawing)
import Data.NavKey as NavKey exposing (NavKey)
import Data.Size exposing (Size)
import Id exposing (Id)
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), (<?>), Parser)
import Url.Parser.Query as Query



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
    | PaintAppWithParams PaintAppParams
    | PaintAppFromUrl String
    | PaintAppFromDrawing (Id Drawing)
    | About
    | Login
    | ResetPassword
    | Logout
    | Settings


type alias PaintAppParams =
    { dimensions : Maybe Size
    , backgroundColor : Maybe BackgroundColor
    , name : Maybe String
    }



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
    , Url.map PaintApp (Url.s "app")
    , Url.map toPaintAppRoute
        (Url.s "app"
            <?> Query.int "width"
            <?> Query.int "height"
            <?> Query.custom
                    "background_color"
                    BackgroundColor.queryParser
            <?> Query.string "name"
        )
    , Url.map PaintAppFromUrl
        (Url.s "app" </> Url.s "url" </> Url.string)
    , Url.map (PaintAppFromDrawing << Id.fromString)
        (Url.s "app" </> Url.s "id" </> Url.string)
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


toPaintAppRoute : Maybe Int -> Maybe Int -> Maybe BackgroundColor -> Maybe String -> Route
toPaintAppRoute maybeWidth maybeHeight maybeBackgroundColor maybeName =
    PaintAppWithParams
        { dimensions =
            Maybe.map2
                Size
                maybeWidth
                maybeHeight
        , backgroundColor = maybeBackgroundColor
        , name = maybeName
        }


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
