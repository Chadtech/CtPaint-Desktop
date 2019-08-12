module Page.ForgotPassword exposing
    ( Model
    , Msg
    , css
    , failed
    , init
    , succeeded
    , track
    , update
    , view
    )

import Css exposing (..)
import Data.Tracking as Tracking
import Helpers.Email
import Html exposing (Html, form, input, p)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg)
import Util



-- TYPES --


type Model
    = Ready ReadyModel
    | Sending String
    | Success String
    | Fail String


type alias ReadyModel =
    { email : String
    , problem : Maybe Problem
    }


type Problem
    = Other String
    | EmailIsntValid


type Msg
    = EmailUpdated String
    | Submitted
    | SubmitClicked
    | Succeeded
    | Failed String


succeeded : Msg
succeeded =
    Succeeded


failed : String -> Msg
failed =
    Failed



-- INIT --


init : Model
init =
    { email = ""
    , problem = Nothing
    }
        |> Ready



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated str ->
            ifReady (updateEmail str) model

        Submitted ->
            attemptSubmit model

        SubmitClicked ->
            attemptSubmit model

        Succeeded ->
            case model of
                Sending email ->
                    Success email
                        |> R2.withNoCmd

                _ ->
                    model
                        |> R2.withNoCmd

        Failed err ->
            case model of
                Sending _ ->
                    Fail err
                        |> R2.withNoCmd

                _ ->
                    model
                        |> R2.withNoCmd


ifReady : (ReadyModel -> ( ReadyModel, Cmd Msg )) -> Model -> ( Model, Cmd Msg )
ifReady readyFunc model =
    case model of
        Ready readyModel ->
            readyFunc readyModel
                |> Tuple.mapFirst Ready

        _ ->
            model
                |> R2.withNoCmd


updateEmail : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updateEmail str readyModel =
    { readyModel
        | email = str
    }
        |> R2.withNoCmd


attemptSubmit : Model -> ( Model, Cmd Msg )
attemptSubmit model =
    case model of
        Ready readyModel ->
            readyModel
                |> setProblem
                |> submitIfNoProblem

        _ ->
            model
                |> R2.withNoCmd


submitIfNoProblem : ReadyModel -> ( Model, Cmd Msg )
submitIfNoProblem readyModel =
    case readyModel.problem of
        Just _ ->
            Ready readyModel
                |> R2.withNoCmd

        Nothing ->
            Sending readyModel.email
                |> R2.withCmd
                    (submit readyModel.email)


submit : String -> Cmd Msg
submit =
    ForgotPassword >> Ports.send



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        EmailUpdated _ ->
            Nothing

        Submitted ->
            Tracking.noProps "submit enter press"

        SubmitClicked ->
            Tracking.noProps "submit click"

        Succeeded ->
            Tracking.response Nothing

        Failed err ->
            Tracking.response (Just err)



-- VALIDATE --


setProblem : ReadyModel -> ReadyModel
setProblem readyModel =
    { readyModel
        | problem = getProblem readyModel
    }


getProblem : ReadyModel -> Maybe Problem
getProblem readyModel =
    [ isEmailValid readyModel.email ]
        |> Util.firstJust


isEmailValid : String -> Maybe Problem
isEmailValid email =
    if Helpers.Email.validate email then
        Nothing

    else
        Just EmailIsntValid



-- STYLES --


type Class
    = Text
    | Long
    | SendingText


css : Stylesheet
css =
    [ Css.class Text
        [ marginRight (px 8) ]
    , Css.class Long
        [ width (px 300) ]
    , Css.class SendingText
        [ marginBottom (px 8) ]
    ]
        |> namespace forgotPasswordNamespace
        |> stylesheet


forgotPasswordNamespace : String
forgotPasswordNamespace =
    Html.Custom.makeNamespace "ForgotPassword"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace forgotPasswordNamespace


view : Model -> Html Msg
view model =
    [ Html.Custom.header
        { text = "forgot password"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ body model ]
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> Html.Custom.background []


body : Model -> Html Msg
body model =
    case model of
        Ready readyModel ->
            readyBody readyModel

        Sending _ ->
            Html.Custom.spinner

        Success email ->
            successBody email

        Fail _ ->
            failView


failView : Html Msg
failView =
    p
        []
        [ Html.text failText ]


failText : String
failText =
    """
    Oh no, something went wrong. Im sorry about that.
    Try again, and if it still doesnt work, please report
    this error to ctpaint@programhouse.us.
    """


successBody : String -> Html Msg
successBody email =
    p
        []
        [ Html.text (successText email) ]


successText : String -> String
successText email =
    [ "Okay, I have sent an email to"
    , email
    , "containing a password reset link."
    ]
        |> String.join " "


readyBody : ReadyModel -> Html Msg
readyBody { email, problem } =
    form
        [ onSubmit Submitted ]
        [ Html.Custom.field []
            [ p
                [ class [ Text ] ]
                [ Html.text "email" ]
            , input
                [ class [ Long ]
                , Attr.value email
                , Attr.spellcheck False
                , onInput EmailUpdated
                ]
                []
            ]
        , Util.viewMaybe problem errorView
        , Html.Custom.menuButton
            [ onClick SubmitClicked ]
            [ Html.text "reset password" ]
        ]


errorView : Problem -> Html Msg
errorView =
    errorMsg >> Html.Custom.error []


errorMsg : Problem -> String
errorMsg problem =
    case problem of
        Other err ->
            err

        EmailIsntValid ->
            "Please enter a valid email address"
