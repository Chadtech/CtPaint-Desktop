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
import Html exposing (Html, a, br, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Route
import Tuple.Infix exposing ((&))


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Succeeded ->
            { model
                | status = Success
            }
                & Cmd.none

        LoginClicked ->
            if model.status == Success then
                model & Route.goTo Route.Home
            else
                model & Cmd.none

        Failed "NotAuthorizedException: User cannot confirm because user status is not UNCONFIRMED." ->
            { model | status = Fail AlreadyVerified }
                & Cmd.none

        Failed err ->
            { model | status = Fail (Other err) }
                & Cmd.none



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
