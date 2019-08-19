module Page.Settings exposing
    ( Model
    , Msg
    , getSession
    )

import Data.Listener as Listener
import Data.User as User exposing (User)
import Session exposing (Session)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session User
    , tab : Tab
    , name : String
    , profilePicUrl : String
    , status : HttpStatus
    }


type HttpStatus
    = Ready
    | Saving
    | Fail String


type Tab
    = UserData
    | KeyConfig


type Msg
    = TabClickedOn Tab
    | NameUpdated String
    | ProfilePicUrlUpdated String
    | SaveClicked
    | GotSaveResponse (Listener.Response String ())



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session User -> Model
init session =
    let
        user : User
        user =
            Session.getViewer session
    in
    { session = session
    , tab = UserData
    , name = User.getName user
    , profilePicUrl =
        User.getProfilePic user
            |> Maybe.withDefault ""
    , status = Ready
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session User
getSession =
    .session
