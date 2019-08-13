module Ui.LoginCard exposing
    ( Model
    , Msg
    , header
    , init
    , track
    , update
    , view
    , viewBody
    )

import Css exposing (Style)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import String.Extra as StringUtil
import Style
import Ui.LoginCard.Field as LoginField exposing (Field)
import Util.Cmd as CmdUtil
import View.Card as Card
import View.CardHeader as CardHeader exposing (CardHeader)
import View.Input as Input exposing (Input)
import View.Label as Label



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { email : Field
    , password : Field
    , httpStatus : Status
    }


type Status
    = Ready
    | LoggingIn
    | Failed String


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | EnterPressed
    | LoginClicked
    | ForgotPasswordClicked



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    { email = LoginField.init
    , password = LoginField.init
    , httpStatus = Ready
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setEmail : String -> Model -> Model
setEmail str model =
    { model
        | email =
            LoginField.setValue str model.email
    }


setPassword : String -> Model -> Model
setPassword str model =
    { model
        | password =
            LoginField.setValue str model.password
    }


loggingIn : Model -> Model
loggingIn model =
    { model | httpStatus = LoggingIn }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


header : CardHeader msg
header =
    CardHeader.config
        { title = "log in" }


view : List (Html msg) -> Html msg
view =
    Card.view
        [ Style.width Style.i8
        , Style.padding Style.i0
        , Css.flex (Css.int 0)
        ]


viewBody : Model -> List (Html Msg)
viewBody model =
    let
        labelView : String -> Input Msg -> Html Msg
        labelView label input =
            Grid.row
                [ Style.marginBottom Style.i0 ]
                [ Label.view
                    label
                    [ Style.width Style.i6
                    , Style.paddingLeft Style.i0
                    , Grid.exactWidthColumn (Css.px 128)
                    ]
                , Grid.column
                    []
                    [ Input.toHtml input ]
                ]
    in
    [ Input.config
        EmailUpdated
        (LoginField.getValue model.email)
        |> labelView "email"
    , Input.config
        PasswordUpdated
        (LoginField.getValue model.password)
        |> labelView "password"
    ]



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        EmailUpdated str ->
            setEmail str model
                |> CmdUtil.withNoCmd

        PasswordUpdated str ->
            setPassword str model
                |> CmdUtil.withNoCmd

        LoginClicked ->
            attemptLogin model

        EnterPressed ->
            attemptLogin model

        ForgotPasswordClicked ->
            ( model
            , Cmd.none
              -- TODO , make the login card
              -- go into a forgot password state
            )


attemptLogin : Model -> ( Model, Cmd Msg )
attemptLogin model =
    let
        validatedModel : Model
        validatedModel =
            { model
                | email = validateEmail model.email
                , password = validatePassword model.password
            }
    in
    case
        ( validatedModel.email.error
        , validatedModel.password.error
        )
    of
        ( Nothing, Nothing ) ->
            ( validatedModel
                |> loggingIn
            , requestLogin
                { email = validatedModel.email.value
                , password = validatedModel.password.value
                }
            )

        _ ->
            validatedModel
                |> CmdUtil.withNoCmd


requestLogin : { email : String, password : String } -> Cmd Msg
requestLogin _ =
    Cmd.none


validateEmail : Field -> Field
validateEmail =
    LoginField.validate
        { valid = not << StringUtil.isBlank
        , errorMessage = "email is required"
        }


validatePassword : Field -> Field
validatePassword =
    LoginField.validate
        { valid = not << StringUtil.isBlank
        , errorMessage = "password is required"
        }


track : Msg -> Maybe Tracking.Event
track =
    trackUnnamespaced
        >> Tracking.tag "login-card"


trackUnnamespaced : Msg -> Maybe Tracking.Event
trackUnnamespaced msg =
    case msg of
        EmailUpdated _ ->
            Nothing

        PasswordUpdated _ ->
            Nothing

        EnterPressed ->
            Tracking.event "enter press"

        LoginClicked ->
            Tracking.event "login click"

        ForgotPasswordClicked ->
            Tracking.event "forgot password click"
