module Page.Logout exposing (..)

import Html exposing (Html, a, br, div, p, text)
import Html.Spinner exposing (spinner)
import Process
import Route exposing (Route(Home))
import Styles exposing (Classes(..))
import Task exposing (Task)
import Util exposing ((&))


-- TYPES --


init : Model
init =
    Waiting


type Model
    = Waiting
    | Success
    | Fail String


type Msg
    = LogoutSuccessful
    | LogoutFailed String
    | DoneWaiting



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LogoutSuccessful ->
            Success & wait

        LogoutFailed err ->
            Fail err & Cmd.none

        DoneWaiting ->
            model & Route.goTo Home


wait : Cmd Msg
wait =
    Process.sleep 5000
        |> Task.perform finishWaiting


finishWaiting : a -> Msg
finishWaiting =
    always DoneWaiting



-- VIEW --


{ class } =
    Styles.helpers


view : Model -> Html Msg
view model =
    div
        [ class [ Card, Solitary ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "log out" ]
            , div
                [ class [ Body ] ]
                (viewContent model)
            ]
        ]


viewContent : Model -> List (Html Msg)
viewContent model =
    case model of
        Waiting ->
            [ p_ "logging out.."
            , spinner
            ]

        Success ->
            [ p_ "You have successfully logged out. You will be redirected momentarily."
            ]

        Fail err ->
            [ p_ "Weird, I couldnt log out."
            , p_ err
            ]


p_ : String -> Html Msg
p_ str =
    p
        [ class [ HasBottomMargin, TextAlignCenter ] ]
        [ text str ]
