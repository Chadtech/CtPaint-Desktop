module Data.NavKey exposing
    ( NavKey
    , fromNativeKey
    , goTo
    )

import Browser.Navigation as Nav



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type NavKey
    = NavKey Nav.Key
    | TestKey



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


fromNativeKey : Nav.Key -> NavKey
fromNativeKey =
    NavKey


goTo : NavKey -> String -> Cmd msg
goTo key url =
    case key of
        NavKey nativeKey ->
            Nav.pushUrl nativeKey url

        TestKey ->
            Cmd.none
