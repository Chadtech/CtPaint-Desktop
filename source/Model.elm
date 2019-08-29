module Model exposing
    ( Model(..)
    , decoder
    , getSession
    , getUser
    , mapSession
    , pageId
    )

import Data.NavKey exposing (NavKey)
import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder)
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
    = Blank { user : User, session : Session }
    | PageNotFound { user : User, session : Session }
    | PaintApp PaintApp.Model
    | Splash Session
    | About { user : User, session : Session }
    | Login Login.Model
    | ResetPassword ResetPassword.Model
    | Settings Settings.Model
    | Home Home.Model
    | Logout Logout.Model
    | Contact Contact.Model



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : NavKey -> Decoder Model
decoder navKey =
    Decode.map2
        (\user session ->
            Blank
                { user = user
                , session = session
                }
        )
        (Decode.field "user" User.decoder)
        (Session.decoder navKey)


getUser : Model -> User
getUser model =
    case model of
        Blank { user } ->
            user

        PageNotFound { user } ->
            user

        PaintApp subModel ->
            PaintApp.getUser subModel

        Splash _ ->
            User.noAccount

        About { user } ->
            user

        Login subModel ->
            Login.getUser subModel

        ResetPassword _ ->
            User.noAccount

        Settings subModel ->
            User.account (Settings.getAccount subModel)

        Home subModel ->
            User.account (Home.getAccount subModel)

        Logout _ ->
            User.noAccount

        Contact subModel ->
            Contact.getUser subModel


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    case model of
        Blank { user, session } ->
            Blank
                { user = user
                , session = f session
                }

        PageNotFound { user, session } ->
            PageNotFound
                { user = user
                , session = f session
                }

        PaintApp subModel ->
            PaintApp (PaintApp.mapSession f subModel)

        Splash session ->
            Splash (f session)

        About { user, session } ->
            About
                { user = user
                , session = f session
                }

        Login subModel ->
            Login (Login.mapSession f subModel)

        ResetPassword subModel ->
            ResetPassword (ResetPassword.mapSession f subModel)

        Settings subModel ->
            Settings (Settings.mapSession f subModel)

        Home subModel ->
            Home (Home.mapSession f subModel)

        Logout subModel ->
            Logout (Logout.mapSession f subModel)

        Contact subModel ->
            Contact (Contact.mapSession f subModel)


getSession : Model -> Session
getSession model =
    case model of
        Blank { session } ->
            session

        PageNotFound { session } ->
            session

        PaintApp subModel ->
            PaintApp.getSession subModel

        Splash session ->
            session

        About { session } ->
            session

        Login subModel ->
            Login.getSession subModel

        ResetPassword subModel ->
            ResetPassword.getSession subModel

        Settings subModel ->
            subModel
                |> Settings.getSession

        Home subModel ->
            Home.getSession subModel

        Logout subModel ->
            Logout.getSession subModel

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
