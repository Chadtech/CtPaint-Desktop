module Page.Login exposing (..)

import Html exposing (Attribute, Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, hidden, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(..))
import Util exposing ((&), showIf)
import Validate exposing (ifBlank)


type alias Model =
    { email : String
    , password : String
    , fieldErrors : List ( Field, String )
    , responseError : Maybe String
    , showFields : Bool
    }


type Field
    = Email
    | Password


type Msg
    = UpdateField Field String
    | AttemptLogin



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , fieldErrors = []
    , responseError = Nothing
    , showFields = True
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        UpdateField Email str ->
            { model | email = str } & Cmd.none

        UpdateField Password str ->
            { model | password = str } & Cmd.none

        AttemptLogin ->
            let
                errors =
                    validate model

                cmd =
                    if List.isEmpty errors then
                        { email = model.email
                        , password = model.password
                        }
                            |> Login
                            |> Ports.send
                    else
                        Cmd.none
            in
            { model
                | fieldErrors = errors
            }
                & cmd



-- VALIDATIONS --


validate : Model -> List ( Field, String )
validate =
    Validate.all
        [ .email >> ifBlank ( Email, "Email field is required" )
        , .password >> ifBlank ( Password, "Password field is required" )
        ]



-- VIEW --


view : Model -> Html Msg
view model =
    let
        value_ : String -> Attribute Msg
        value_ =
            value << showIf model.showFields

        errorView_ : Field -> Html Msg
        errorView_ =
            errorView model.fieldErrors
    in
    div
        [ class "card solitary" ]
        [ form
            [ onSubmit AttemptLogin ]
            [ p [] [ text "CtPaint Log In" ]
            , field
                "Email"
                [ value_ model.email
                , onInput_ Email
                ]
            , errorView_ Email
            , field
                "Password"
                [ value_ model.password
                , type_ "password"
                , onInput_ Password
                ]

            -- This input is here, because without it
            -- the enter key does not cause submission
            , input
                [ type_ "submit"
                , hidden True
                ]
                []
            , a
                [ onClick AttemptLogin ]
                [ text "Log in" ]
            ]
        ]



-- COMPONENT HTML --


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    div
        [ class "field" ]
        [ p [] [ text name ]
        , input
            attributes
            []
        ]


errorView : List ( Field, String ) -> Field -> Html Msg
errorView errors fieldType =
    let
        thisFieldsErrors =
            List.filter
                (Tuple.first >> (==) fieldType)
                errors
    in
    case thisFieldsErrors of
        [] ->
            Html.text ""

        error :: _ ->
            let
                str =
                    Tuple.second error
            in
            div
                [ class "error-zone" ]
                [ p [] [ text str ] ]



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    UpdateField >> onInput
