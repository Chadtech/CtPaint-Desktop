module Page.Logout exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, br, div, p)
import Html.CssHelpers
import Html.Custom
import Ports
import Return2 as R2
import Tracking exposing (Event(PageLogoutFail))


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


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        LogoutFailed err ->
            PageLogoutFail err
                |> Ports.track taco
                |> R2.withModel (Fail err)



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

        Fail err ->
            [ p [] [ Html.text "Weird, I couldnt log out." ]
            , p [] [ Html.text err ]
            ]
