module Ui.LoginCard exposing
    ( Model
    , Msg
    , header
    , init
    , listeners
    , track
    , update
    , view
    , viewBody
    )

import Css exposing (Style)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html.Styled exposing (Html)
import Ports
import Style
import Ui.LoginCard.ForgotPassword as ForgotPassword
import Ui.LoginCard.Login as Login
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import Util.Tuple as TupleUtil
import Util.Tuple3 as Tuple3
import View.Card as Card
import View.CardHeader as CardHeader exposing (CardHeader)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Login Login.Model
    | ForgotPassword ForgotPassword.Model


type Msg
    = LoginMsg Login.Msg
    | ForgotPasswordMsg ForgotPassword.Msg



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    Login Login.init



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


header : Model -> CardHeader msg
header model =
    CardHeader.config
        { title =
            case model of
                Login _ ->
                    "log in"

                ForgotPassword _ ->
                    "forgot password"
        }


view : List (Html msg) -> Html msg
view =
    Card.view [ Style.width 9 ]


viewBody : Model -> List (Html Msg)
viewBody model =
    case model of
        Login subModel ->
            Login.view subModel
                |> HtmlUtil.mapList LoginMsg

        ForgotPassword subModel ->
            ForgotPassword.view subModel
                |> HtmlUtil.mapList ForgotPasswordMsg



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg, Maybe User )
update msg model =
    case msg of
        LoginMsg subMsg ->
            case model of
                Login subModel ->
                    updateLogin subMsg subModel

                ForgotPassword _ ->
                    model
                        |> CmdUtil.justModel

        ForgotPasswordMsg subMsg ->
            case model of
                ForgotPassword subModel ->
                    ForgotPassword.update subMsg subModel
                        |> CmdUtil.mapModel ForgotPassword
                        |> CmdUtil.mapCmd ForgotPasswordMsg
                        |> TupleUtil.append Nothing

                Login _ ->
                    model
                        |> CmdUtil.justModel


updateLogin : Login.Msg -> Login.Model -> ( Model, Cmd Msg, Maybe User )
updateLogin msg model =
    case msg of
        Login.EmailUpdated str ->
            Login.setEmail str model
                |> Login
                |> CmdUtil.justModel

        Login.PasswordUpdated str ->
            Login.setPassword str model
                |> Login
                |> CmdUtil.justModel

        Login.LoginClicked ->
            attemptLogin model

        Login.EnterPressed ->
            attemptLogin model

        Login.ForgotPasswordClicked ->
            ForgotPassword ForgotPassword.init
                |> CmdUtil.justModel

        Login.GotLoginResponse response ->
            case response of
                Ok user ->
                    ( Login model
                    , Cmd.none
                    , Just user
                    )

                Err error ->
                    model
                        |> Login.fail error
                        |> Login
                        |> CmdUtil.justModel

        Login.TryAgainClicked ->
            Login Login.init
                |> CmdUtil.justModel


attemptLogin : Login.Model -> ( Model, Cmd Msg, Maybe effect )
attemptLogin model =
    Tuple3.mapFirst Login <|
        case Login.validate model of
            Ok { email, password } ->
                ( Login.loggingIn model
                , Ports.payload "log in"
                    |> Ports.withString "email" email
                    |> Ports.withString "password" password
                    |> Ports.send
                , Nothing
                )

            Err newModel ->
                newModel
                    |> CmdUtil.justModel


track : Msg -> Maybe Tracking.Event
track msg =
    Tracking.tag "login-card" <|
        case msg of
            LoginMsg subMsg ->
                Login.track subMsg

            ForgotPasswordMsg subMsg ->
                ForgotPassword.track subMsg
                    |> Tracking.tag "forgot-password"



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listeners : List (Listener Msg)
listeners =
    [ Login.listener
        |> Listener.map LoginMsg
    , ForgotPassword.listener
        |> Listener.map ForgotPasswordMsg
    ]
