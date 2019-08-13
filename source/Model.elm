module Model exposing
    ( Model(..)
    , getSession
    )

import Page.Login as Login
import Page.PaintApp as PaintApp
import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Blank Session
    | PaintApp PaintApp.Model
    | Splash Session
    | About Session
    | Login Login.Model



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession model =
    case model of
        Blank session ->
            session

        PaintApp subModel ->
            PaintApp.getSession subModel

        Splash session ->
            session

        About session ->
            session

        Login subModel ->
            Login.getSession subModel
