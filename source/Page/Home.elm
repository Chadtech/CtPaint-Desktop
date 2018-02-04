module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div, text)
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = Noop


type alias Model =
    {}



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            , NoReply
            )



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace homeNamespace
        |> stylesheet


homeNamespace : String
homeNamespace =
    Html.Custom.makeNamespace "Home"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace homeNamespace


view : Model -> List (Html Msg)
view model =
    []
