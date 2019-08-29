module Page.ResetPassword exposing
    ( Model
    , Msg
    , getSession
    , init
    , listener
    , mapSession
    , track
    , update
    , view
    )

import Data.Account as User
import Data.Document exposing (Document)
import Data.Field as Field exposing (Field)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Ports
import Route
import Session exposing (Session)
import Style
import Util.Cmd as CmdUtil
import Util.Function as FunctionUtil
import Util.Json.Decode as DecodeUtil
import Util.Maybe as MaybeUtil
import Util.String as StringUtil
import View.Button as Button
import View.ButtonRow as ButtonRow
import View.Card as Card
import View.CardHeader as CardHeader
import View.Input as Input exposing (Input)
import View.InputGroup as InputGroup
import View.SingleCardPage as SingleCardPage
import View.Spinner as Spinner



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , email : Field
    , code : Field
    , password : Field
    , passwordConfirm : Field
    , status : HttpStatus
    }


type HttpStatus
    = Ready
    | Waiting
    | Success
    | Fail (Listener.Error Error)


type Error
    = InvalidCode
    | Other String


type Msg
    = GotResetPasswordResponse (Listener.Response Error ())
    | LoginClicked
    | TryAgainClicked
    | EmailUpdated String
    | CodeUpdated String
    | PasswordUpdated String
    | PasswordConfirmUpdated String
    | ResetPasswordClicked
    | EnterPressed



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session
      , email = Field.init
      , code = Field.init
      , password = Field.init
      , passwordConfirm = Field.init
      , status = Ready
      }
    , Ports.logout
    )



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


errorToString : Error -> String
errorToString error =
    case error of
        InvalidCode ->
            "invalid code"

        Other str ->
            str


setStatus : HttpStatus -> Model -> Model
setStatus status model =
    { model | status = status }


setEmail : String -> Model -> Model
setEmail newEmail model =
    { model | email = Field.setValue newEmail model.email }


setCode : String -> Model -> Model
setCode newCode model =
    { model | code = Field.setValue newCode model.code }


setPassword : String -> Model -> Model
setPassword newPassword model =
    { model
        | password =
            Field.setValue newPassword model.password
    }


setPasswordConfirm : String -> Model -> Model
setPasswordConfirm newPasswordConfirm model =
    { model
        | passwordConfirm =
            Field.setValue newPasswordConfirm model.passwordConfirm
    }


validate : Model -> Result Model { email : String, code : String, newPassword : String }
validate model =
    let
        validatedModel : Model
        validatedModel =
            { model
                | email = Field.validateEmail model.email
                , code =
                    Field.validate
                        { valid = not << StringUtil.isBlank
                        , errorMessage = "you must enter your reset code"
                        }
                        model.code
                , password = Field.validatePassword model.password
                , passwordConfirm =
                    Field.validate
                        { valid = (==) (Field.getValue model.password)
                        , errorMessage = "the passwords you entered do not match"
                        }
                        model.passwordConfirm
            }
    in
    case
        MaybeUtil.firstValue
            [ Field.getError validatedModel.email
            , Field.getError validatedModel.code
            , Field.getError validatedModel.password
            , Field.getError validatedModel.passwordConfirm
            ]
    of
        Just _ ->
            Err validatedModel

        Nothing ->
            { code = Field.getValue validatedModel.code
            , newPassword = Field.getValue validatedModel.password
            , email = Field.getValue validatedModel.email
            }
                |> Ok



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResetPasswordResponse result ->
            case model.status of
                Waiting ->
                    case result of
                        Ok () ->
                            setStatus
                                Success
                                model
                                |> CmdUtil.withNoCmd

                        Err error ->
                            setStatus
                                (Fail error)
                                model
                                |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        LoginClicked ->
            ( model
            , Route.goTo
                (Session.getNavKey model.session)
                Route.Login
            )

        TryAgainClicked ->
            init model.session

        EmailUpdated newEmail ->
            setEmail newEmail model
                |> CmdUtil.withNoCmd

        CodeUpdated newCode ->
            setCode newCode model
                |> CmdUtil.withNoCmd

        PasswordUpdated newPassword ->
            setPassword newPassword model
                |> CmdUtil.withNoCmd

        PasswordConfirmUpdated newPasswordConfirm ->
            setPasswordConfirm newPasswordConfirm model
                |> CmdUtil.withNoCmd

        ResetPasswordClicked ->
            attemptSubmission model

        EnterPressed ->
            attemptSubmission model


attemptSubmission : Model -> ( Model, Cmd msg )
attemptSubmission model =
    case model.status of
        Ready ->
            case validate model of
                Ok { newPassword, email, code } ->
                    ( setStatus Waiting model
                    , Ports.payload "reset password"
                        |> Ports.withString "email" email
                        |> Ports.withString "code" code
                        |> Ports.withString "password" newPassword
                        |> Ports.send
                    )

                Err validatedModel ->
                    validatedModel
                        |> CmdUtil.withNoCmd

        _ ->
            model
                |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        GotResetPasswordResponse response ->
            Tracking.event "got reset password response"
                |> Tracking.withListenerResponse
                    (Listener.mapError errorToString response)

        LoginClicked ->
            Tracking.event "login clicked"

        TryAgainClicked ->
            Tracking.event "try again clicked"

        EmailUpdated _ ->
            Nothing

        CodeUpdated _ ->
            Nothing

        PasswordUpdated _ ->
            Nothing

        PasswordConfirmUpdated _ ->
            Nothing

        EnterPressed ->
            Tracking.event "enter pressed"

        ResetPasswordClicked ->
            Tracking.event "reset password clicked"



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        title : String
        title =
            "reset password"

        header : Html Msg
        header =
            CardHeader.config
                { title = title }
                |> CardHeader.toHtml
    in
    { title = Just title
    , body =
        Card.view
            [ Style.width 9 ]
            (header :: viewBody model)
            |> SingleCardPage.view
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.status of
        Ready ->
            [ Html.form
                []
                [ inputGroupView
                    { label = "email"
                    , onInput = EmailUpdated
                    , options = [ Input.withAutocomplete "email" ]
                    , field = model.email
                    }
                , inputGroupView
                    { label = "code"
                    , onInput = CodeUpdated
                    , options = []
                    , field = model.code
                    }
                , inputGroupView
                    { label = "new password"
                    , onInput = PasswordUpdated
                    , options =
                        [ Input.isPassword
                        , Input.withAutocomplete "new-password"
                        ]
                    , field = model.password
                    }
                , inputGroupView
                    { label = "confirm new password"
                    , onInput = PasswordConfirmUpdated
                    , options =
                        [ Input.isPassword
                        , Input.withAutocomplete "new-password"
                        ]
                    , field = model.passwordConfirm
                    }
                ]
            , ButtonRow.view
                [ Button.config
                    ResetPasswordClicked
                    "reset password"
                    |> Button.asDoubleWidth
                ]
            ]

        Waiting ->
            [ Spinner.row ]

        Success ->
            [ Card.textRow
                []
                """
                    Great. It worked. Your password has been reset.
                    Now go back to the login in page and use your
                    new password.
                    """
            , ButtonRow.view
                [ Button.config
                    LoginClicked
                    "go to login"
                ]
            ]

        Fail error ->
            errorView error


errorView : Listener.Error Error -> List (Html msg)
errorView error =
    let
        problemRow : String -> Html msg
        problemRow =
            Card.textRow
                [ Style.problemBackground ]
    in
    case error of
        Listener.DecodeError decodeError ->
            [ problemRow
                """
                Im really sorry. Something really broke.
                Please let me know that you had this problem
                by emailing me at chadtech0@gmail.com. Below
                is the error that occurred:
                """
            , Card.errorDisplay
                (Decode.errorToString decodeError)
            ]

        Listener.Error InvalidCode ->
            [ problemRow
                """
                The reset code was invalid. 
                If you requested this code a while ago, 
                then its probably expired. 
                Sorry. Please try again."
                """
            ]

        Listener.Error (Other str) ->
            [ problemRow
                """
                Sorry, something unexpected happened. 
                Please let me know that you had this problem
                by emailing me at chadtech0@gmail.com. Below
                is the error that occurred:
                """
            , Card.errorDisplay str
            ]


inputGroupView :
    { label : String
    , onInput : String -> Msg
    , options : List (Input Msg -> Input Msg)
    , field : Field
    }
    -> Html Msg
inputGroupView { label, options, onInput, field } =
    InputGroup.text
        { label = label
        , input =
            Input.config
                onInput
                (Field.getValue field)
                |> FunctionUtil.composeMany options
                |> Input.onEnter EnterPressed
        }
        |> InputGroup.withStyles [ Style.marginBottom 1 ]
        |> InputGroup.withError (Field.getError field)
        |> InputGroup.withDoubleWidth
        |> InputGroup.toHtml



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listener : Listener Msg
listener =
    Listener.for
        { name = "reset password"
        , decoder =
            [ Decode.map Ok (Decode.null ())
            , DecodeUtil.matchString "ExpiredCodeException" InvalidCode
                |> Decode.field "name"
                |> Decode.map Err
            ]
                |> Decode.oneOf
        , handler = GotResetPasswordResponse
        }
