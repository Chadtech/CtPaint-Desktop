module Page.Logout exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, br, div, p)
import Html.CssHelpers
import Html.Custom
import Process
import Return2 as R2
import Route exposing (Route(Landing))
import Task exposing (Task)


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
            Success
                |> R2.withCmd wait

        LogoutFailed err ->
            Fail err
                |> R2.withNoCmd

        DoneWaiting ->
            Route.goTo Landing
                |> R2.withModel model


wait : Cmd Msg
wait =
    Process.sleep 5000
        |> Task.perform finishWaiting


finishWaiting : a -> Msg
finishWaiting =
    always DoneWaiting



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace logoutNamespace
        |> stylesheet


logoutNamespace : String
logoutNamespace =
    Html.Custom.makeNamespace "Logout"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace logoutNamespace


view : Model -> Html Msg
view model =
    Html.Custom.card []
        [ Html.Custom.header
            { text = "log out"
            , closability = Html.Custom.NotClosable
            }
        , Html.Custom.cardBody [] (viewContent model)
        ]


viewContent : Model -> List (Html Msg)
viewContent model =
    case model of
        Waiting ->
            [ p [] [ Html.text "logging out.." ]
            , Html.Custom.spinner
            ]

        Success ->
            [ p [] [ Html.text "You have successfully logged out. You will be redirected momentarily." ]
            ]

        Fail err ->
            [ p [] [ Html.text "Weird, I couldnt log out." ]
            , p [] [ Html.text err ]
            ]
