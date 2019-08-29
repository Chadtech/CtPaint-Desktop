module Page.Login exposing
    ( Model
    , Msg
    , getSession
    , getUser
    , init
    , listeners
    , mapSession
    , track
    , update
    , view
    )

import Data.Account exposing (Account)
import Data.Document exposing (Document)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Data.User as User exposing (User)
import Html.Styled exposing (Html)
import Ports
import Route
import Session exposing (Session)
import Ui.LoginCard as LoginCard
import Util.Html as HtmlUtil
import Util.Tuple3 as Tuple3
import View.CardHeader as CardHeader exposing (CardHeader)
import View.SingleCardPage as SingleCardPage



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , user : User
    , loginCard : LoginCard.Model
    }


type Msg
    = LoginCardMsg LoginCard.Msg



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , user = User.noAccount
      , loginCard = LoginCard.init
      }
    , Ports.logout
    )



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setLoginCard : LoginCard.Model -> Model -> Model
setLoginCard newLoginCard model =
    { model | loginCard = newLoginCard }


loggedIn : Account -> Model -> Model
loggedIn account model =
    { model | user = User.account account }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        header : Html Msg
        header =
            LoginCard.header
                model.loginCard
                |> CardHeader.toHtml

        body : List (Html Msg)
        body =
            LoginCard.viewBody
                model.loginCard
                |> HtmlUtil.mapList LoginCardMsg
    in
    { title = Just "log in"
    , body =
        SingleCardPage.view
            (LoginCard.view (header :: body))
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginCardMsg subMsg ->
            let
                ( newLoginCardModel, cmd, maybeUser ) =
                    LoginCard.update
                        subMsg
                        model.loginCard
                        |> Tuple3.mapSecond
                            (Cmd.map LoginCardMsg)

                modelWithCard : Model
                modelWithCard =
                    setLoginCard
                        newLoginCardModel
                        model
            in
            case maybeUser of
                Just newUser ->
                    ( loggedIn newUser modelWithCard
                    , Cmd.batch
                        [ Route.goTo
                            (Session.getNavKey model.session)
                            Route.Landing
                        , cmd
                        ]
                    )

                Nothing ->
                    ( modelWithCard
                    , cmd
                    )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        LoginCardMsg subMsg ->
            LoginCard.track subMsg



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listeners : List (Listener Msg)
listeners =
    LoginCard.listeners
        |> Listener.mapMany LoginCardMsg
