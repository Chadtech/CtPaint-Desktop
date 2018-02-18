module Page.Settings
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
import Data.User exposing (User)
import Html exposing (Html)
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(NoReply, SetUser))


-- TYPES --


type alias Model =
    { page : Page }


type Page
    = KeyConfig
    | User


type Msg
    = NavClickedOn Page



-- INIT --


init : Model
init =
    { page = KeyConfig }



-- UPDATE --


update : Msg -> User -> Model -> ( Model, Cmd Msg, Reply )
update msg user model =
    case msg of
        NavClickedOn page ->
            ( { model | page = page }
            , Cmd.none
            , NoReply
            )



-- STYLES --


type Class
    = KeyCmds


css : Stylesheet
css =
    [ Css.class KeyCmds
        []
    ]
        |> namespace settingsNamespace
        |> stylesheet


settingsNamespace : String
settingsNamespace =
    Html.Custom.makeNamespace "Settings"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace settingsNamespace


view : Model -> List (Html Msg)
view model =
    []
