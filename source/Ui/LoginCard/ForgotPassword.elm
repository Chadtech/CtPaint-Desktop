module Ui.LoginCard.ForgotPassword exposing
    ( Model
    , Msg
    , init
    , listener
    , track
    , update
    , view
    )

import Data.Field as Field exposing (Field)
import Data.Listener as Listener exposing (Listener)
import Data.Tracking as Tracking
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Ports
import Style
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import Util.Json.Decode as DecodeUtil
import View.Button as Button
import View.Card as Card
import View.Input as Input
import View.InputGroup as InputGroup
import View.Spinner as Spinner
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Model
    = Ready Field
    | Waiting { email : String }
    | Success { email : String }
    | Fail { error : Listener.Error Error }


type Error
    = UserDoesntExist


type Msg
    = ReadyMsg ReadyMsg
    | GotForgetPasswordResponse (Listener.Response Error ())


type ReadyMsg
    = EmailUpdated String
    | ResetPasswordClicked
    | EnterPressed



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Model
init =
    Ready Field.init



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


errorToId : Error -> String
errorToId error =
    case error of
        UserDoesntExist ->
            "user doesnt exist"


validate : Field -> Result Field { email : String }
validate model =
    let
        validatedField : Field
        validatedField =
            Field.validateEmail model
    in
    case Field.getError validatedField of
        Just _ ->
            Err validatedField

        Nothing ->
            Ok { email = Field.getValue validatedField }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> List (Html Msg)
view model =
    case model of
        Ready email ->
            [ Html.form
                []
                [ InputGroup.text
                    { label = "email"
                    , input =
                        Input.config
                            EmailUpdated
                            (Field.getValue email)
                            |> Input.withAutocomplete "email"
                            |> Input.onEnter EnterPressed
                    }
                    |> InputGroup.withError (Field.getError email)
                    |> InputGroup.toHtml
                ]
            , Button.rowWithStyles
                [ Style.fieldMarginTop ]
                [ Button.config
                    ResetPasswordClicked
                    "reset password"
                    |> Button.asDoubleWidth
                ]
            ]
                |> HtmlUtil.mapList ReadyMsg

        Waiting _ ->
            [ Spinner.row ]

        Success { email } ->
            [ [ "Okay, I have sent an email to"
              , email
              , "containing a password reset link. Check your email to proceed."
              ]
                |> String.join " "
                |> Text.fromString
            ]

        Fail _ ->
            [ Card.textRow
                [ Style.problemBackground ]
                """
                Oh no, something went wrong. Im sorry about that.
                Try again, and if it still doesnt work, please report
                this error to chadtech0@gmail.com .
                """
            ]



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReadyMsg subMsg ->
            case model of
                Ready subModel ->
                    updateReady subMsg subModel

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        GotForgetPasswordResponse result ->
            case model of
                Waiting email ->
                    case result of
                        Ok () ->
                            Success email
                                |> CmdUtil.withNoCmd

                        Err error ->
                            { error = error
                            }
                                |> Fail
                                |> CmdUtil.withNoCmd

                _ ->
                    model
                        |> CmdUtil.withNoCmd


updateReady : ReadyMsg -> Field -> ( Model, Cmd Msg )
updateReady msg model =
    case msg of
        EmailUpdated newEmail ->
            Field.setValue newEmail model
                |> Ready
                |> CmdUtil.withNoCmd

        ResetPasswordClicked ->
            attemptReset model

        EnterPressed ->
            attemptReset model


attemptReset : Field -> ( Model, Cmd Msg )
attemptReset field =
    case validate field of
        Ok email ->
            ( Waiting email
            , requestReset email
            )

        Err newField ->
            Ready newField
                |> CmdUtil.withNoCmd


requestReset : { email : String } -> Cmd Msg
requestReset { email } =
    Ports.payload "forgot password"
        |> Ports.withString "email" email
        |> Ports.send


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        ReadyMsg readyMsg ->
            trackReady readyMsg

        GotForgetPasswordResponse response ->
            Tracking.event "got forget password response"
                |> Tracking.withListenerResponse
                    (Listener.mapError errorToId response)


trackReady : ReadyMsg -> Maybe Tracking.Event
trackReady msg =
    case msg of
        EmailUpdated _ ->
            Nothing

        ResetPasswordClicked ->
            Tracking.event "reset password clicked"

        EnterPressed ->
            Tracking.event "enter pressed"



-------------------------------------------------------------------------------
-- PORTS --
-------------------------------------------------------------------------------


listener : Listener Msg
listener =
    Listener.for
        { name = "forgot password"
        , decoder =
            [ Decode.map Ok (Decode.null ())
            , DecodeUtil.matchStringMany
                [ ( "UserNotFoundException", UserDoesntExist ) ]
                |> Decode.field "name"
                |> Decode.map Err
            ]
                |> Decode.oneOf
        , handler = GotForgetPasswordResponse
        }
