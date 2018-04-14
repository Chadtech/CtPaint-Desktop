module Page.Logout
    exposing
        ( Model
        , Msg(LogoutFailed)
        , css
        , init
        , track
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Html exposing (Html, p)
import Html.CssHelpers
import Html.Custom
import Json.Encode as Encode
import Util exposing (def)


-- TYPES --


init : Model
init =
    Waiting


type Model
    = Waiting
    | Fail String


type Msg
    = LogoutFailed String



-- UPDATE --


update : Msg -> Model
update msg =
    case msg of
        LogoutFailed err ->
            Fail err



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        LogoutFailed err ->
            err
                |> Encode.string
                |> def "error"
                |> List.singleton
                |> def "logout-fail"
                |> Just



-- STYLES --


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

        Fail err ->
            [ p [] [ Html.text "Weird, I couldnt log out." ]
            , p [] [ Html.text err ]
            ]
