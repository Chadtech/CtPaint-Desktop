module Model exposing
    ( Model(..)
    , getSession
    , pageId
    )

import Data.Viewer as Viewer exposing (Viewer)
import Page.Home as Home
import Page.Login as Login
import Page.PaintApp as PaintApp
import Page.ResetPassword as ResetPassword
import Page.Settings as Settings
import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Blank (Session Viewer)
    | PageNotFound (Session Viewer)
    | PaintApp PaintApp.Model
    | Splash (Session ())
    | About (Session Viewer)
    | Login Login.Model
    | ResetPassword (Session ()) ResetPassword.Model
    | Settings Settings.Model
    | Offline (Session ())
    | Home Home.Model



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session Viewer
getSession model =
    case model of
        Blank session ->
            session

        PageNotFound session ->
            session

        PaintApp subModel ->
            PaintApp.getSession subModel

        Splash session ->
            Session.setViewer
                Viewer.Viewer
                session

        About session ->
            session

        Login subModel ->
            Login.getSession subModel

        ResetPassword session _ ->
            Session.setViewer
                Viewer.Viewer
                session

        Settings subModel ->
            subModel
                |> Settings.getSession
                |> Session.mapViewer Viewer.User


pageId : Model -> String
pageId model =
    case model of
        Blank _ ->
            "blank"

        PageNotFound _ ->
            "page-not-found"

        PaintApp _ ->
            "paint-app"

        Splash _ ->
            "splash"

        About _ ->
            "about"

        Login _ ->
            "login"

        ResetPassword _ _ ->
            "reset-password"

        Settings _ ->
            "settings"
