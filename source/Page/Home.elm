module Page.Home exposing (..)

import Html exposing (Html, div, text)
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = Noop


type Reply
    = NoReply


type alias Model =
    {}



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        Noop ->
            model & NoReply



-- VIEW --


view : Model -> Html Msg
view model =
    div
        []
        [ text "Home!" ]
