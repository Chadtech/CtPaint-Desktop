module Page.Settings exposing
    ( Model
    , Msg
    , getAccount
    , getSession
    , init
    , mapSession
    , track
    , update
    , view
    )

import Data.Account as Account exposing (Account)
import Data.Document exposing (Document)
import Data.Field as Field exposing (Field)
import Data.Listener as Listener
import Data.Tracking as Tracking
import Ports
import Session exposing (Session)
import Util.Cmd as CmdUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , account : Account
    , tab : Tab
    , nameField : Field
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
    | SaveClicked
    | GotSaveResponse (Listener.Response String ())



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Account -> Model
init session account =
    { session = session
    , account = account
    , tab = Account
    , nameField =
        account
            |> Account.getName
            |> Field.initWithValue
    , status = Ready
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getAccount : Model -> Account
getAccount =
    .account


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



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
    { model
        | nameField =
            Field.setValue newName model.nameField
    }


toAccount : Model -> Account
toAccount model =
    { email = model.account.email
    , name = Field.getValue model.nameField
    }


hasChanges : Model -> Bool
hasChanges model =
    toAccount model /= model.account


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

        SaveClicked ->
            if canSave model then
                ( saving model
                , Ports.payload "update user"
                    |> Ports.withString "email" model.account.email
                    |> Ports.withString "name" (Field.getValue model.nameField)
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

        SaveClicked ->
            Tracking.event "save clicked"

        GotSaveResponse response ->
            Tracking.event "got save response"
                |> Tracking.withListenerResponse response
