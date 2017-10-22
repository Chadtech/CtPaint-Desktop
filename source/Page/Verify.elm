module Page.Verify exposing (..)

import Html exposing (Html, a, br, div, p, text)
import Html.Attributes exposing (class)


-- INIT --


init : String -> Model
init =
    Waiting



-- TYPES --


type Model
    = Waiting String
    | Success String
    | Fail String


type Msg
    = VerificationSuccess String
    | VerificationFail String



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        VerificationSuccess email ->
            ( Success email, Cmd.none )

        VerificationFail err ->
            ( Fail err, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Waiting email ->
            [ p [] [ text "Verifying.." ] ]
                |> container

        Success email ->
            [ p
                []
                [ text "Done!" ]
            , br [] []
            , p
                []
                [ text (email ++ " is verified.") ]
            , br [] []
            , a
                []
                [ text "Log In" ]
            ]
                |> container

        Fail err ->
            [ p
                []
                [ text "Error" ]
            , br [] []
            , p
                []
                [ text err ]
            ]
                |> container


container : List (Html Msg) -> Html Msg
container =
    div [ class "card solitary" ]
