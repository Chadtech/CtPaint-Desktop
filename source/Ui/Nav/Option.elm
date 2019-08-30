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
    | Contact
    | Login
    | Logout
    | Account



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

        Account ->
            "account"

        Contact ->
            "contact"


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

        Account ->
            Route.Settings

        Contact ->
            Route.Contact


encode : Option -> Encode.Value
encode =
    toLabel >> Encode.string
