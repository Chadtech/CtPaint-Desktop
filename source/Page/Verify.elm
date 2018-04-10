module Page.Verify
    exposing
        ( Model
        , Msg(Failed, Succeeded)
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, br, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Ports
import Return2 as R2
import Route
import Tracking
    exposing
        ( Event
            ( PageVerifyLoginClick
            , PageVerifyResponse
            )
        )


-- INIT --


init : String -> Model
init email =
    { email = email
    , status = Waiting
    }



-- TYPES --


type alias Model =
    { email : String
    , status : Status
    }


type Status
    = Waiting
    | Success
    | Fail Problem


type Msg
    = Succeeded
    | Failed String
    | LoginClicked


type Problem
    = AlreadyVerified
    | Other String



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        Succeeded ->
            PageVerifyResponse Nothing
                |> Ports.track taco
                |> R2.withModel
                    { model
                        | status = Success
                    }

        LoginClicked ->
            if model.status == Success then
                [ Route.goTo Route.Login
                , PageVerifyLoginClick False
                    |> Ports.track taco
                ]
                    |> Cmd.batch
                    |> R2.withModel model
            else
                PageVerifyLoginClick True
                    |> Ports.track taco
                    |> R2.withModel model

        Failed err ->
            handleFail taco model err


handleFail : Taco -> Model -> String -> ( Model, Cmd Msg )
handleFail taco model err =
    err
        |> Just
        |> PageVerifyResponse
        |> Ports.track taco
        |> R2.withModel
            { model | status = Fail (toProblem err) }


toProblem : String -> Problem
toProblem err =
    case err of
        "NotAuthorizedException: User cannot confirm because user status is not UNCONFIRMED." ->
            AlreadyVerified

        _ ->
            Other err



-- STYLES --


type Class
    = Verifying


css : Stylesheet
css =
    [ Css.class Verifying
        [ textAlign center
        , children
            [ Css.Elements.p
                [ marginBottom (px 8) ]
            ]
        ]
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


errorMsg : Problem -> String
errorMsg problem =
    case problem of
        AlreadyVerified ->
            "This email is already verified, so you should be good to go."

        Other err ->
            "Sorry, there was an unknown error. Heres the error message : " ++ err
