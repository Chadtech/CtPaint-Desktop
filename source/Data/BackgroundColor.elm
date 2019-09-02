module Data.BackgroundColor exposing
    ( BackgroundColor
    , black
    , queryParser
    , toString
    , toStyleColor
    , white
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------

import Css


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
