module Data.BackgroundColor exposing
    ( BackgroundColor
    , black
    , encode
    , queryParser
    , toString
    , toStyleColor
    , white
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------

import Css
import Json.Encode as Encode


type BackgroundColor
    = Black
    | White



-------------------------------------------------------------------------------
--  VALUES --
-------------------------------------------------------------------------------


black : BackgroundColor
black =
    Black


white : BackgroundColor
white =
    White



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


encode : BackgroundColor -> Encode.Value
encode =
    toString >> Encode.string


toString : BackgroundColor -> String
toString color =
    case color of
        Black ->
            "black"

        White ->
            "white"


queryParser : List String -> Maybe BackgroundColor
queryParser params =
    case params of
        [] ->
            Nothing

        "black" :: _ ->
            Just black

        "white" :: _ ->
            Just white

        _ :: rest ->
            queryParser rest


toStyleColor : BackgroundColor -> Css.Color
toStyleColor color =
    case color of
        Black ->
            Css.hex "#000000"

        White ->
            Css.hex "#FFFFFF"
