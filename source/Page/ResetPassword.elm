module Page.ResetPassword exposing
    ( Model
    , Msg
    , init
    , listener
    , track
    , update
    , view
    )

import Data.Document exposing (Document)
import Data.Field as Field exposing (Field)
import Data.Listener as Listener exposing (Listener)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Ports
import Route
import Style
import Util.Cmd as CmdUtil
import Util.Function as FunctionUtil
import Util.Html as HtmlUtil
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
import View.TextArea as TextArea



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Ready ReadyModel
    | Waiting
    | Success
    | Fail (Listener.Error Error)


type Error
    = InvalidCode
    | Other String


type alias ReadyModel =
    { email : Field
    , code : Field
    , password : Field
    , passwordConfirm : Field
    , error : Maybe String
    }


type Msg
    = ReadyMsg ReadyMsg
    | GotResetPasswordResponse (Listener.Response Error ())
    | LoginClicked
    | TryAgainClicked


type ReadyMsg
    = EmailUpdated String
    | CodeUpdated String
    | PasswordUpdated String
    | PasswordConfirmUpdated String
    | ResetPasswordClicked
    | EnterPressed



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    Ready
        { email = Field.init
        , code = Field.init
        , password = Field.init
        , passwordConfirm = Field.init
        , error = Nothing
        }



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


setEmail : String -> ReadyModel -> ReadyModel
setEmail newEmail model =
    { model | email = Field.setValue newEmail model.email }


setCode : String -> ReadyModel -> ReadyModel
setCode newCode model =
    { model | code = Field.setValue newCode model.code }


setPassword : String -> ReadyModel -> ReadyModel
setPassword newPassword model =
    { model
        | password =
            Field.setValue newPassword model.password
    }


setPasswordConfirm : String -> ReadyModel -> ReadyModel
setPasswordConfirm newPasswordConfirm model =
    { model
        | passwordConfirm =
            Field.setValue newPasswordConfirm model.passwordConfirm
    }


validate :
    ReadyModel
    ->
        Result ReadyModel
            { email : String
            , code : String
            , newPassword : String
            }
validate model =
    let
        validatedModel : ReadyModel
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


update : NavKey -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        ReadyMsg readyMsg ->
            case model of
                Ready readyModel ->
                    updateReady readyMsg readyModel

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        GotResetPasswordResponse result ->
            case model of
                Waiting ->
                    case result of
                        Ok () ->
                            Success
                                |> CmdUtil.withNoCmd

                        Err error ->
                            error
                                |> Fail
                                |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        LoginClicked ->
            ( model
            , Route.goTo navKey Route.Login
            )

        TryAgainClicked ->
            init
                |> CmdUtil.withNoCmd


updateReady : ReadyMsg -> ReadyModel -> ( Model, Cmd Msg )
updateReady msg model =
    case msg of
        EmailUpdated newEmail ->
            setEmail newEmail model
                |> Ready
                |> CmdUtil.withNoCmd

        CodeUpdated newCode ->
            setCode newCode model
                |> Ready
                |> CmdUtil.withNoCmd

        PasswordUpdated newPassword ->
            setPassword newPassword model
                |> Ready
                |> CmdUtil.withNoCmd

        PasswordConfirmUpdated newPasswordConfirm ->
            setPasswordConfirm newPasswordConfirm model
                |> Ready
                |> CmdUtil.withNoCmd

        ResetPasswordClicked ->
            attemptSubmission model

        EnterPressed ->
            attemptSubmission model


attemptSubmission : ReadyModel -> ( Model, Cmd msg )
attemptSubmission model =
    case validate model of
        Ok { newPassword, email, code } ->
            ( Waiting
            , Ports.payload "reset password"
                |> Ports.withString "email" email
                |> Ports.withString "code" code
                |> Ports.withString "password" newPassword
                |> Ports.send
            )

        Err validatedModel ->
            Ready validatedModel
                |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        ReadyMsg readyMsg ->
            trackReady readyMsg

        GotResetPasswordResponse response ->
            Tracking.event "got reset password response"
                |> Tracking.withListenerResponse
                    (Listener.mapError errorToString response)

        LoginClicked ->
            Tracking.event "login clicked"

        TryAgainClicked ->
            Tracking.event "try again clicked"


trackReady : ReadyMsg -> Maybe Tracking.Event
trackReady msg =
    case msg of
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
    case model of
        Ready readyModel ->
            [ Html.form
                []
                [ inputGroupView
                    { label = "email"
                    , onInput = EmailUpdated
                    , options = [ Input.withAutocomplete "email" ]
                    , field = readyModel.email
                    }
                , inputGroupView
                    { label = "code"
                    , onInput = CodeUpdated
                    , options = []
                    , field = readyModel.code
                    }
                , inputGroupView
                    { label = "new password"
                    , onInput = PasswordUpdated
                    , options =
                        [ Input.isPassword
                        , Input.withAutocomplete "new-password"
                        ]
                    , field = readyModel.password
                    }
                , inputGroupView
                    { label = "confirm new password"
                    , onInput = PasswordConfirmUpdated
                    , options =
                        [ Input.isPassword
                        , Input.withAutocomplete "new-password"
                        ]
                    , field = readyModel.passwordConfirm
                    }
                ]
            , ButtonRow.view
                [ Button.config
                    ResetPasswordClicked
                    "reset password"
                    |> Button.asDoubleWidth
                ]
            ]
                |> HtmlUtil.mapList ReadyMsg

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
    , onInput : String -> ReadyMsg
    , options : List (Input ReadyMsg -> Input ReadyMsg)
    , field : Field
    }
    -> Html ReadyMsg
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
