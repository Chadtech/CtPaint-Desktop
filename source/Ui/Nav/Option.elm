module Ui.Nav.Option exposing
    ( Option(..)
    , encode
    , toLabel
    , toRoute
    )

import Json.Encode as Encode
import Route exposing (Route)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Option
    = Draw
    | Title
    | About
    | Login
    | Logout
    | Settings



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


toLabel : Option -> String
toLabel option =
    case option of
        Draw ->
            "draw"

        Title ->
            "title"

        About ->
            "about"

        Login ->
            "log in"

        Logout ->
            "log out"

        Settings ->
            "settings"


toRoute : Option -> Route
toRoute option =
    case option of
        Draw ->
            Route.paintApp

        Title ->
            Route.Landing

        About ->
            Route.About

        Login ->
            Route.Login

        Logout ->
            Route.Logout

        Settings ->
            Route.Settings


encode : Option -> Encode.Value
encode =
    toLabel >> Encode.string
