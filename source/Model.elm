module Model exposing
    ( Model(..)
    , getSession
    )

import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Blank Session
    | Splash Session



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession model =
    case model of
        Blank session ->
            session

        Splash session ->
            session
