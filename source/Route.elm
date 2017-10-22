module Route exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, s)


type Route
    = Home
    | Settings
    | Login
    | Logout
    | Register
    | Verify String String
    | PaintApp


fromLocation : Location -> Maybe Route
fromLocation =
    Url.parsePath route


route : Parser (Route -> a) a
route =
    [ Url.map Home (s "")
    , Url.map Login (s "login")
    , Url.map Logout (s "logout")
    , Url.map Register (s "register")
    , Url.map Settings (s "settings")
    , Url.map PaintApp (s "app")
    , Url.map Verify (s "verify" </> Url.string </> Url.string)
    ]
        |> Url.oneOf
