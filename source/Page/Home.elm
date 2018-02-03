module Page.Home exposing (..)

import Html exposing (Html, div, text)
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



-- VIEW --


view : Model -> Html Msg
view model =
    div
        []
        [ text "Home!" ]
