module Ui.LoginCard.Login exposing
    ( Model
    , Msg(..)
    , Status
    , fail
    , init
    , listener
    , loggingIn
    , setEmail
    , setPassword
    , track
    , validate
    , view
    )

import Data.Account as User exposing (Account)
import Data.Field as Field exposing (Field)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Style
import Util.Function as FunctionUtil
import Util.Json.Decode as DecodeUtil
import View.Button as Button
import View.ButtonRow as ButtonRow
import View.Card as Card
import View.Input as Input exposing (Input)
import View.InputGroup as InputGroup
import View.Link as Link
import View.Spinner as Spinner



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
    | Failed (Listener.Error Error)


type Error
    = IncorrectCredentials
    | PasswordResetRequired


type Msg
    = EmailUpdated String
    | PasswordUpdated String
    | EnterPressed
    | LoginClicked
    | ForgotPasswordClicked
    | TryAgainClicked
    | GotLoginResponse (Listener.Response Error Account)



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    { email = Field.init
    , password = Field.init
    , httpStatus = Ready
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


setEmail : String -> Model -> Model
setEmail str model =
    { model
        | email =
            Field.setValue str model.email
    }


setPassword : String -> Model -> Model
setPassword str model =
    { model
        | password =
            Field.setValue str model.password
    }


loggingIn : Model -> Model
loggingIn model =
    { model | httpStatus = LoggingIn }


fail : Listener.Error Error -> Model -> Model
fail error model =
    { model | httpStatus = Failed error }


validate : Model -> Result Model { email : String, password : String }
validate model =
    let
        validatedModel : Model
        validatedModel =
            { model
                | email = Field.validateEmail model.email
                , password = Field.validatePassword model.password
            }
    in
    case
        ( Field.getError validatedModel.email
        , Field.getError validatedModel.password
        )
    of
        ( Nothing, Nothing ) ->
            { email = Field.getValue validatedModel.email
            , password = Field.getValue validatedModel.password
            }
                |> Ok

        _ ->
            Err validatedModel



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> List (Html Msg)
view model =
    case model.httpStatus of
        Ready ->
            [ Html.form
                []
                [ inputGroupView
                    { label = "email"
                    , onInput = EmailUpdated
                    , options =
                        [ Input.withAutocomplete "email" ]
                    , field = model.email
                    }
                , inputGroupView
                    { label = "password"
                    , onInput = PasswordUpdated
                    , options =
                        [ Input.isPassword
                        , Input.withAutocomplete "current-password"
                        ]
                    , field = model.password
                    }
                ]
            , Link.config
                ForgotPasswordClicked
                "I forgot my password"
                |> Link.toHtml
            , ButtonRow.view
                [ Button.config LoginClicked "log in" ]
            ]

        LoggingIn ->
            [ Spinner.row ]

        Failed error ->
            List.append
                (errorView error)
                [ ButtonRow.view
                    [ Button.config
                        TryAgainClicked
                        "try again"
                    ]
                ]


errorView : Listener.Error Error -> List (Html Msg)
errorView listenerError =
    let
        problemRow : String -> Html msg
        problemRow =
            Card.textRow
                [ Style.problemBackground
                , Style.marginBottom 1
                ]
    in
    case listenerError of
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

        Listener.Error error ->
            [ problemRow (errorMsg error) ]


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
        |> InputGroup.toHtml


errorMsg : Error -> String
errorMsg error =
    case error of
        IncorrectCredentials ->
            "Either the user does not exist or the password you entered was incorrect"

        PasswordResetRequired ->
            "Please reset your password"


errorToId : Error -> String
errorToId error =
    case error of
        IncorrectCredentials ->
            "incorrect credentials"

        PasswordResetRequired ->
            "password reset required"



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


track : Msg -> Maybe Tracking.Event
track msg =
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

        GotLoginResponse response ->
            Tracking.event "got login response"
                |> Tracking.withListenerResponse
                    (Listener.mapError errorToId response)

        TryAgainClicked ->
            Tracking.event "try again clicked"



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listener : Listener Msg
listener =
    Listener.for
        { name = "login"
        , decoder =
            [ Decode.map Ok User.decoder
            , DecodeUtil.matchStringMany
                [ ( "UserNotFoundException", IncorrectCredentials )
                , ( "NotAuthorizedException", IncorrectCredentials )
                , ( "PasswordResetRequiredException", PasswordResetRequired )
                ]
                |> Decode.field "name"
                |> Decode.map Err
            ]
                |> Decode.oneOf
        , handler = GotLoginResponse
        }
