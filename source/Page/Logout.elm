module Page.Logout exposing
    ( Model
    , Msg
    , getSession
    , init
    , track
    , update
    , view
    )

import Data.Account as User
import Data.Document exposing (Document)
import Data.Listener as Listener
import Data.Tracking as Tracking
import Ports
import Route
import Session exposing (Session)
import Util.Cmd as CmdUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session User.None
    , status : HttpStatus
    }


type HttpStatus
    = Waiting
    | Fail String


type Msg
    = GotLogoutResponse (Listener.Response String ())



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session User.None -> ( Model, Cmd msg )
init session =
    ( { session = session
      , status = Waiting
      }
    , Ports.withNoProps "log out"
    )



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session User.None
getSession =
    .session



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setError : String -> Model -> Model
setError error model =
    { model | status = Fail error }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotLogoutResponse response ->
            case response of
                Ok () ->
                    ( model
                    , Route.goTo
                        (Session.getNavKey model.session)
                        Route.Landing
                    )

                Err error ->
                    setError
                        (Listener.errorToString identity error)
                        model
                        |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        GotLogoutResponse response ->
            Tracking.event "got logout response"
                |> Tracking.withListenerResponse response



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document msg
view model =
    { title = Nothing
    , body =
        []
    }



--
--viewContent : Model -> List (Html Msg)
--viewContent model =
--    case model of
--        Waiting ->
--            [ p [] [ Html.text "logging out.." ]
--            , Html.Custom.spinner
--            ]
--
--        Fail err ->
--            [ p [] [ Html.text "Weird, I couldnt log out." ]
--            , p [] [ Html.text err ]
--            ]
