module Page.ResetPassword
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Ports exposing (JsMsg(ResetPassword))
import Route
import Tuple.Infix exposing ((&))


-- TYPES --


type Model
    = Ready ReadyModel
    | Sending
    | Success
    | Fail


type alias ReadyModel =
    { email : String
    , code : String
    , password : String
    , passwordConfirm : String
    , errors : List String
    }


type Msg
    = GoHomeClicked


init : String -> String -> Model
init email code =
    { email = email
    , code = code
    , password = ""
    , passwordConfirm = ""
    , errors = []
    }
        |> Ready



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoHomeClicked ->
            model & Route.goTo Route.Landing



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace resetNamespace
        |> stylesheet


resetNamespace : String
resetNamespace =
    Html.Custom.makeNamespace "ResetPassword"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace resetNamespace


view : Model -> Html Msg
view model =
    [ Html.Custom.header
        { text = "reset password"
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
    Html.text "yeeeee"
