module Page.Verify exposing (..)

import Html exposing (Html, a, br, div, p, text)
import Html.Events exposing (onClick)
import Html.Spinner exposing (spinner)
import Styles exposing (Classes(..))
import Util exposing ((&))


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



-- VIEW --


{ class } =
    Styles.helpers


view : Model -> Html Msg
view model =
    div
        [ class [ Card, Solitary, Verify ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "verify account" ] ]
        , div
            [ class [ Body ] ]
            (viewBody model)
        ]


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.status of
        Waiting ->
            [ p
                [ class [ HasBottomMargin, TextAlignCenter ] ]
                [ text "verifying.." ]
            , spinner
            ]

        Success ->
            [ p [] [ text "Success!" ]
            , br [] []
            , p
                []
                [ text (model.email ++ " is verified.") ]
            , br [] []
            , a [] [ text "log in" ]
            ]

        Fail err ->
            [ p
                []
                [ text "Error" ]
            , br [] []
            , p
                []
                [ text err ]
            ]
