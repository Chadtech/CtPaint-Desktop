module Route exposing (..)

import Navigation exposing (Location)


type Route
    = Home
    | Settings
    | Login
    | Logout
    | Register
    | Preference


fromLocation : Location -> Maybe Route
fromLocation location =
    Just Home
