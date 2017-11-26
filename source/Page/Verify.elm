module Page.Verify exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, br, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
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
    | Fail String


type Msg
    = Succeeded
    | Failed String



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Succeeded ->
            { model
                | status = Success
            }
                & Cmd.none

        Failed err ->
            { model | status = Fail err } & Cmd.none



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace verifyNamespace
        |> stylesheet


verifyNamespace : String
verifyNamespace =
    "Verify"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace verifyNamespace


view : Model -> Html Msg
view model =
    Html.Custom.card []
        [ Html.Custom.header
            { text = "verify account"
            , closability = Html.Custom.NotClosable
            }
        , Html.Custom.cardBody [] (viewBody model)
        ]


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.status of
        Waiting ->
            [ p [] [ Html.text "verifying.." ]
            , Html.Custom.spinner
            ]

        Success ->
            [ p [] [ Html.text "Success!" ]
            , br [] []
            , p
                []
                [ Html.text (model.email ++ " is verified.") ]
            , br [] []
            , a [] [ Html.text "log in" ]
            ]

        Fail err ->
            [ p
                []
                [ Html.text "Error" ]
            , br [] []
            , p
                []
                [ Html.text err ]
            ]
