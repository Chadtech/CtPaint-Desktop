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


toRoute : Option -> Route
toRoute option =
    case option of
        Draw ->
            Route.PaintApp

        Title ->
            Route.Landing

        About ->
            Route.About

        Login ->
            Route.Login


encode : Option -> Encode.Value
encode =
    toLabel >> Encode.string
