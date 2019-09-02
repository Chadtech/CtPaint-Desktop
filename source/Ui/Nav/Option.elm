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
    = NewDrawing
    | Drawings
    | About
    | Login
    | Logout
    | Account



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


toLabel : Option -> String
toLabel option =
    case option of
        NewDrawing ->
            "new drawing"

        Drawings ->
            "drawings"

        About ->
            "about"

        Login ->
            "log in"

        Logout ->
            "log out"

        Account ->
            "account"


toRoute : Option -> Route
toRoute option =
    case option of
        NewDrawing ->
            Route.InitDrawing

        Drawings ->
            Route.drawings

        About ->
            Route.about

        Login ->
            Route.Login

        Logout ->
            Route.Logout

        Account ->
            Route.Settings


encode : Option -> Encode.Value
encode =
    toLabel >> Encode.string
