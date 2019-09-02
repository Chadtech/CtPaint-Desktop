module Route.Drawings exposing
    ( Route(..)
    , parser
    , toUrlPieces
    )

import Data.Drawing exposing (Drawing)
import Id exposing (Id)
import Url.Parser as Url exposing ((</>), Parser, s)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Route
    = Landing
    | SpecificDrawing (Id Drawing)



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


parser : Parser (Route -> a) a
parser =
    [ Url.map Landing Url.top
    , Url.map SpecificDrawing
        (Url.top </> Url.map Id.fromString Url.string)
    ]
        |> Url.oneOf


toUrlPieces : Route -> List String
toUrlPieces route =
    case route of
        Landing ->
            []

        SpecificDrawing id ->
            [ "id", Id.toString id ]
