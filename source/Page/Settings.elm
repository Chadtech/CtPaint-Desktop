module Page.Settings exposing
    ( Model
    , Msg
    , getSession
    , init
    , track
    , update
    , view
    )

import Data.Account as User exposing (Account)
import Data.Document exposing (Document)
import Data.Listener as Listener
import Data.Tracking as Tracking
import Ports
import Session exposing (Session)
import Util.Cmd as CmdUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session Account
    , tab : Tab
    , name : String
    , profilePicUrl : String
    , status : HttpStatus
    }


type HttpStatus
    = Ready
    | Saving
    | Fail (Listener.Error String)


type Tab
    = Account
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


init : Session Account -> Model
init session =
    let
        user : Account
        user =
            Session.getUser session
    in
    { session = session
    , tab = Account
    , name = User.getName user
    , profilePicUrl =
        User.getProfilePic user
            |> Maybe.withDefault ""
    , status = Ready
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session Account
getSession =
    .session



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


tabToLabel : Tab -> String
tabToLabel tab =
    case tab of
        Account ->
            "account"

        KeyConfig ->
            "key config"


fail : Listener.Error String -> Model -> Model
fail error model =
    { model | status = Fail error }


becomeReady : Model -> Model
becomeReady model =
    { model | status = Ready }


saving : Model -> Model
saving model =
    { model | status = Saving }


setTab : Tab -> Model -> Model
setTab tab model =
    { model | tab = tab }


setName : String -> Model -> Model
setName newName model =
    { model | name = newName }


setProfilePicUrl : String -> Model -> Model
setProfilePicUrl newUrl model =
    { model | profilePicUrl = newUrl }


toUser : Model -> Account
toUser model =
    let
        user : Account
        user =
            Session.getUser model.session
    in
    { email = user.email
    , name = model.name
    , profilePic =
        case model.profilePicUrl of
            "" ->
                Nothing

            _ ->
                Just model.profilePicUrl
    }


hasChanges : Model -> Bool
hasChanges model =
    toUser model /= Session.getUser model.session


canSave : Model -> Bool
canSave model =
    model.status == Ready && not (hasChanges model)



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    { title = Just "settings"
    , body = []

    -- TODO this page
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabClickedOn tab ->
            setTab tab model
                |> CmdUtil.withNoCmd

        NameUpdated nameField ->
            setName nameField model
                |> CmdUtil.withNoCmd

        ProfilePicUrlUpdated newUrl ->
            setProfilePicUrl newUrl model
                |> CmdUtil.withNoCmd

        SaveClicked ->
            if canSave model then
                ( saving model
                , Ports.payload "update user"
                    |> Ports.withString "email" (Session.getUser model.session).email
                    |> Ports.withString "name" model.name
                    |> Ports.withString "profilePicUrl"
                        (case model.profilePicUrl of
                            "" ->
                                "NONE"

                            _ ->
                                model.profilePicUrl
                        )
                    |> Ports.send
                )

            else
                model
                    |> CmdUtil.withNoCmd

        GotSaveResponse response ->
            case response of
                Ok () ->
                    becomeReady model
                        |> CmdUtil.withNoCmd

                Err error ->
                    fail error model
                        |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        TabClickedOn tab ->
            Tracking.event "tab clicked"
                |> Tracking.withString "tab" (tabToLabel tab)

        NameUpdated _ ->
            Nothing

        ProfilePicUrlUpdated _ ->
            Nothing

        SaveClicked ->
            Tracking.event "save clicked"

        GotSaveResponse response ->
            Tracking.event "got save response"
                |> Tracking.withListenerResponse response
