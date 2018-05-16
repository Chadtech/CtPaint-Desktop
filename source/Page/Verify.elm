module Page.Verify
    exposing
        ( Model
        , Msg(Failed, Succeeded)
        , css
        , init
        , track
        , update
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Html exposing (Html, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
import Ports exposing (JsMsg(VerifyEmail))
import Return2 as R2
import Route
import Util exposing (def)


-- INIT --


init : Model
init =
    { email = ""
    , status = InputCode ""
    }



-- TYPES --


type alias Model =
    { email : String
    , status : Status
    }


type Status
    = InputCode String
    | Waiting
    | Success
    | Fail Problem


type Msg
    = FieldUpdated Field String
    | VerifyClicked
    | Succeeded
    | Failed String
    | LoginClicked


type Field
    = Email
    | Code


type Problem
    = AlreadyVerified
    | EmailCodeComboBad
    | Other String



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated field str ->
            updateField field str model
                |> R2.withNoCmd

        VerifyClicked ->
            case model.status of
                InputCode code ->
                    VerifyEmail model.email code
                        |> Ports.send
                        |> R2.withModel
                            { model | status = Waiting }

                _ ->
                    model
                        |> R2.withNoCmd

        Succeeded ->
            { model
                | status = Success
            }
                |> R2.withNoCmd

        LoginClicked ->
            if canClickLogin model then
                Route.goTo Route.Login
                    |> R2.withModel model
            else
                model
                    |> R2.withNoCmd

        Failed err ->
            handleFail model err


updateField : Field -> String -> Model -> Model
updateField field str model =
    case field of
        Email ->
            { model | email = str }

        Code ->
            case model.status of
                InputCode _ ->
                    { model | status = InputCode str }

                _ ->
                    model


canClickLogin : Model -> Bool
canClickLogin model =
    model.status == Success


handleFail : Model -> String -> ( Model, Cmd Msg )
handleFail model err =
    { model | status = Fail (toProblem err) }
        |> R2.withNoCmd


toProblem : String -> Problem
toProblem err =
    case err of
        "NotAuthorizedException: User cannot confirm because user status is not UNCONFIRMED." ->
            AlreadyVerified

        "UserNotFoundException: Username/client id combination not found." ->
            EmailCodeComboBad

        _ ->
            Other err



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        FieldUpdated field _ ->
            Nothing

        VerifyClicked ->
            Tracking.noProps "verify click"

        Succeeded ->
            Tracking.response Nothing

        LoginClicked ->
            [ model
                |> canClickLogin
                |> not
                |> Encode.bool
                |> def "disabled"
            ]
                |> def "login click"
                |> Just

        Failed err ->
            Tracking.response (Just err)



-- STYLES --


type Class
    = Verifying
    | Text
    | Long


css : Stylesheet
css =
    [ Css.class Verifying
        [ textAlign center
        , children
            [ Css.Elements.p
                [ marginBottom (px 8) ]
            ]
        ]
    , Css.class Text
        [ width (px 120) ]
    , Css.class Long
        [ width (px 300) ]
    ]
        |> namespace verifyNamespace
        |> stylesheet


verifyNamespace : String
verifyNamespace =
    Html.Custom.makeNamespace "Verify"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace verifyNamespace


view : Model -> Html Msg
view model =
    Html.Custom.cardSolitary []
        [ Html.Custom.header
            { text = "verify account"
            , closability = Html.Custom.NotClosable
            }
        , viewBody model
        ]


viewBody : Model -> Html Msg
viewBody model =
    case model.status of
        InputCode code ->
            inputCodeView model.email code

        Waiting ->
            [ p [] [ Html.text ("verifying " ++ model.email) ]
            , Html.Custom.spinner
            ]
                |> Html.Custom.cardBody [ class [ Verifying ] ]

        Success ->
            let
                msg =
                    [ "Success!"
                    , model.email
                    , "is now verified."
                    ]
                        |> String.join " "
            in
            [ p [] [ Html.text msg ]
            , Html.Custom.menuButton
                [ onClick LoginClicked ]
                [ Html.text "log in" ]
            ]
                |> Html.Custom.cardBody []

        Fail err ->
            [ p
                []
                [ Html.text (errorMsg err) ]
            ]
                |> Html.Custom.cardBody []


inputCodeView : String -> String -> Html Msg
inputCodeView email code =
    [ Html.Custom.field
        []
        [ p
            [ class [ Text ] ]
            [ Html.text "email" ]
        , input
            [ class [ Long ]
            , Attrs.value email
            , Attrs.spellcheck False
            , onInput (FieldUpdated Email)
            ]
            []
        ]
    , Html.Custom.field
        []
        [ p
            [ class [ Text ] ]
            [ Html.text "code" ]
        , input
            [ class [ Long ]
            , Attrs.value code
            , Attrs.spellcheck False
            , onInput (FieldUpdated Code)
            ]
            []
        ]
    , Html.Custom.menuButton
        [ onClick VerifyClicked ]
        [ Html.text "verify" ]
    ]
        |> Html.Custom.cardBody []


errorMsg : Problem -> String
errorMsg problem =
    case problem of
        AlreadyVerified ->
            "This email is already verified, so you should be good to go."

        EmailCodeComboBad ->
            "Either your code or email was incorrect. Please try again."

        Other err ->
            "Sorry, there was an unknown error. Heres the error message : " ++ err
