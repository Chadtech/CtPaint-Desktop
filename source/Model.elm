module Model exposing
    ( Model(..)
    , getSession
    , pageId
    )

import Data.Account as User
import Data.User as Viewer exposing (User)
import Page.Contact as Contact
import Page.Home as Home
import Page.Login as Login
import Page.Logout as Logout
import Page.PaintApp as PaintApp
import Page.ResetPassword as ResetPassword
import Page.Settings as Settings
import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Blank (Session User)
    | PageNotFound (Session User)
    | PaintApp PaintApp.Model
    | Splash (Session User.None)
    | About (Session User)
    | Login Login.Model
    | ResetPassword ResetPassword.Model
    | Settings Settings.Model
    | Home Home.Model
    | Logout Logout.Model
    | Contact Contact.Model



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session User
getSession model =
    case model of
        Blank session ->
            session

        PageNotFound session ->
            session

        PaintApp subModel ->
            PaintApp.getSession subModel

        Splash session ->
            Session.setUser
                Viewer.User
                session

        About session ->
            session

        Login subModel ->
            Login.getSession subModel

        ResetPassword subModel ->
            ResetPassword.getSession subModel
                |> Session.setUser Viewer.User

        Settings subModel ->
            subModel
                |> Settings.getSession
                |> Session.mapViewer Viewer.Account

        Home subModel ->
            Home.getSession subModel
                |> Session.mapViewer Viewer.Account

        Logout subModel ->
            Logout.getSession subModel
                |> Session.setUser Viewer.User

        Contact subModel ->
            Contact.getSession subModel


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

        ResetPassword _ ->
            "reset-password"

        Settings _ ->
            "settings"

        Home _ ->
            "home"

        Logout _ ->
            "logout"

        Contact _ ->
            "contact"
