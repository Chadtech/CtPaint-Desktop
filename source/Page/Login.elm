module Page.Login exposing (..)

import Html exposing (Attribute, Html, a, div, form, input, p, text)
import Html.Attributes exposing (hidden, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(..))
import Styles exposing (Classes(..))
import Util exposing ((&), showIf)
import Validate exposing (ifBlank)


type alias Model =
    { email : String
    , password : String
    , errors : List ( Field, String )
    , responseError : Maybe String
    , showFields : Bool
    }


type Field
    = Email
    | Password


type Msg
    = UpdateField Field String
    | AttemptLogin
    | LoginFailed String



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , errors = []
    , responseError = Nothing
    , showFields = True
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                        Login model.email model.password
                            |> Ports.send
                    else
                        Cmd.none
            in
            { model | errors = errors } & cmd

        LoginFailed err ->
            { model
                | responseError =
                    Just (determineResponseError err)
            }
                & Cmd.none


determineResponseError : String -> String
determineResponseError err =
    case err of
        "UserNotFoundException: User does not exist." ->
            "Either the user does not exist or the password entered was incorrect"

        "NotAuthorizedException: Incorrect username or password." ->
            "Either the user does not exist or the password entered was incorrect"

        "PasswordResetRequiredException: Password reset required for the user" ->
            "Please reset your password"

        _ ->
            err



-- VALIDATIONS --


validate : Model -> List ( Field, String )
validate =
    Validate.all
        [ .email >> ifBlank ( Email, "Email field is required" )
        , .password >> ifBlank ( Password, "Password field is required" )
        ]



-- VIEW --


{ class } =
    Styles.helpers


view : Model -> Html Msg
view model =
    let
        value_ : String -> Attribute Msg
        value_ =
            value << showIf model.showFields

        errorView_ : Field -> Html Msg
        errorView_ =
            fieldErrorView model.errors
    in
    div
        [ class [ Card, Solitary ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "CtPaint" ] ]
        , div
            [ class [ Body ] ]
            [ form
                [ onSubmit AttemptLogin ]
                [ field "email"
                    [ value_ model.email
                    , onInput_ Email
                    ]
                , errorView_ Email
                , field "password"
                    [ value_ model.password
                    , type_ "password"
                    , onInput_ Password
                    ]
                , responseErrorView model.responseError
                , input
                    [ type_ "submit"
                    , hidden True
                    ]
                    []
                , a
                    [ class [ Submit ]
                    , onClick AttemptLogin
                    ]
                    [ text "Log in" ]
                ]
            ]
        ]



-- COMPONENT HTML --


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    div
        [ class [ Field ] ]
        [ p [] [ text name ]
        , input
            (class [ Long ] :: attributes)
            []
        ]


fieldErrorView : List ( Field, String ) -> Field -> Html Msg
fieldErrorView errors fieldType =
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
            errorView (Tuple.second error)


responseErrorView : Maybe String -> Html Msg
responseErrorView maybeError =
    case maybeError of
        Just error ->
            errorView error

        Nothing ->
            Html.text ""


errorView : String -> Html Msg
errorView error =
    div
        [ class [ Error ] ]
        [ p [] [ text error ] ]



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    UpdateField >> onInput
