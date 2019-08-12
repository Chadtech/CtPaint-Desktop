module Ui.Nav.Option exposing
    ( Option(..)
    , encode
    , toLabel
    )

import Json.Encode as Encode



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Option
    = Draw
    | Home



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


toLabel : Option -> String
toLabel option =
    case option of
        Draw ->
            "draw"

        Home ->
            "home"


encode : Option -> Encode.Value
encode =
    toLabel >> Encode.string
