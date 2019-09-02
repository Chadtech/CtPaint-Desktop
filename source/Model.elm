module Model exposing
    ( Model(..)
    , decoder
    , getSession
    , getUser
    , mapSession
    , pageId
    , toRoute
    )

import Data.NavKey exposing (NavKey)
import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder)
import Page.About as About
import Page.Drawings as Drawings
import Page.InitDrawing as InitDrawing
import Page.Login as Login
import Page.Logout as Logout
import Page.PaintApp as PaintApp
import Page.ResetPassword as ResetPassword
import Page.Settings as Settings
import Route exposing (Route)
import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Blank UserSession
    | PageNotFound UserSession
    | PaintApp PaintApp.Model
    | About About.Model
    | Login Login.Model
    | ResetPassword ResetPassword.Model
    | Settings Settings.Model
    | Drawings Drawings.Model
    | Logout Logout.Model
    | InitDrawing InitDrawing.Model


type alias UserSession =
    { user : User
    , session : Session
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : NavKey -> Decoder Model
decoder navKey =
    Decode.map2 UserSession
        (Decode.field "user" User.decoder)
        (Session.decoder navKey)
        |> Decode.map Blank


getUser : Model -> User
getUser model =
    case model of
        Blank { user } ->
            user

        PageNotFound { user } ->
            user

        PaintApp subModel ->
            PaintApp.getUser subModel

        About subModel ->
            About.getUser subModel

        Login subModel ->
            Login.getUser subModel

        ResetPassword _ ->
            User.noAccount

        Settings subModel ->
            User.account (Settings.getAccount subModel)

        Drawings subModel ->
            User.account (Drawings.getAccount subModel)

        Logout _ ->
            User.noAccount

        InitDrawing subModel ->
            InitDrawing.getUser subModel


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

        About subModel ->
            About (About.mapSession f subModel)

        Login subModel ->
            Login (Login.mapSession f subModel)

        ResetPassword subModel ->
            ResetPassword (ResetPassword.mapSession f subModel)

        Settings subModel ->
            Settings (Settings.mapSession f subModel)

        Drawings subModel ->
            Drawings (Drawings.mapSession f subModel)

        Logout subModel ->
            Logout (Logout.mapSession f subModel)

        InitDrawing subModel ->
            InitDrawing (InitDrawing.mapSession f subModel)


getSession : Model -> Session
getSession model =
    case model of
        Blank { session } ->
            session

        PageNotFound { session } ->
            session

        PaintApp subModel ->
            PaintApp.getSession subModel

        About subModel ->
            About.getSession subModel

        Login subModel ->
            Login.getSession subModel

        ResetPassword subModel ->
            ResetPassword.getSession subModel

        Settings subModel ->
            subModel
                |> Settings.getSession

        Drawings subModel ->
            Drawings.getSession subModel

        Logout subModel ->
            Logout.getSession subModel

        InitDrawing subModel ->
            InitDrawing.getSession subModel


pageId : Model -> String
pageId model =
    case model of
        Blank _ ->
            "blank"

        PageNotFound _ ->
            "page-not-found"

        PaintApp _ ->
            "paint-app"

        About _ ->
            "about"

        Login _ ->
            "login"

        ResetPassword _ ->
            "reset-password"

        Settings _ ->
            "settings"

        Drawings _ ->
            "home"

        Logout _ ->
            "logout"

        InitDrawing _ ->
            "init-drawing"


toRoute : Model -> Maybe Route
toRoute model =
    case model of
        Blank _ ->
            Nothing

        PageNotFound _ ->
            Nothing

        PaintApp _ ->
            Just Route.paintApp

        About _ ->
            Just Route.about

        Login _ ->
            Just Route.Login

        ResetPassword _ ->
            Just Route.ResetPassword

        Settings _ ->
            Just Route.Settings

        Drawings _ ->
            Just Route.drawings

        Logout _ ->
            Just Route.Logout

        InitDrawing _ ->
            Just Route.InitDrawing
