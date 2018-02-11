module Page.Login
    exposing
        ( Model
        , Msg(LoginFailed)
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html, a, div, form, input, p, text)
import Html.Attributes as Attr
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(..))
import Tuple.Infix exposing ((&))
import Util
import Validate exposing (ifBlank)


type alias Model =
    { email : String
    , password : String
    , errors : List ( Field, String )
    , responseError : Maybe String
    , show : Bool
    }


type Field
    = Email
    | Password


type Msg
    = FieldUpdated Field String
    | Submitted
    | LoginClicked
    | LoginFailed String



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , errors = []
    , responseError = Nothing
    , show = True
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated Email str ->
            { model | email = str } & Cmd.none

        FieldUpdated Password str ->
            { model | password = str } & Cmd.none

        Submitted ->
            attemptLogin model

        LoginClicked ->
            attemptLogin model

        LoginFailed err ->
            { model
                | responseError =
                    Just (determineResponseError err)
                , show = True
            }
                & Cmd.none


attemptLogin : Model -> ( Model, Cmd Msg )
attemptLogin model =
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
    { model
        | errors = errors
        , password = ""
        , show = False
        , responseError = Nothing
    }
        & cmd


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
    [ .email >> ifBlank ( Email, "Email field is required" )
    , .password >> ifBlank ( Password, "Password field is required" )
    ]
        |> Validate.all



-- STYLES --


type Class
    = Text
    | Long
    | Background


css : Stylesheet
css =
    [ Css.class Text [ width (px 120) ]
    , Css.class Long [ width (px 300) ]
    , Css.class Background
        [ position absolute
        , top zero
        , left zero
        , bottom zero
        , right zero
        , backgroundColor backgroundx2
        ]
    ]
        |> namespace loginNamespace
        |> stylesheet


loginNamespace : String
loginNamespace =
    Html.Custom.makeNamespace "Login"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace loginNamespace


view : Model -> Html Msg
view model =
    let
        value_ : String -> Attribute Msg
        value_ =
            Attr.value << Util.showIf model.show

        errorView_ : Field -> Html Msg
        errorView_ =
            fieldErrorView model.errors
    in
    [ Html.Custom.header
        { text = "CtPaint"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ form
            [ onSubmit Submitted ]
            [ field "email"
                [ value_ model.email
                , onInput_ Email
                ]
            , errorView_ Email
            , field "password"
                [ value_ model.password
                , Attr.type_ "password"
                , onInput_ Password
                ]
            , responseErrorView model.responseError
            , input
                [ Attr.type_ "submit"
                , Attr.hidden True
                ]
                []
            , Html.Custom.menuButton
                [ onClick LoginClicked ]
                [ Html.text "log in" ]
            ]
        ]
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> div [ class [ Background ] ]



-- COMPONENT HTML --


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field []
        [ p [ class [ Text ] ] [ Html.text name ]
        , input (class [ Long ] :: attributes) []
        ]


fieldErrorView : List ( Field, String ) -> Field -> Html Msg
fieldErrorView errors field =
    let
        thisFieldsErrors =
            List.filter
                (Tuple.first >> (==) field)
                errors
    in
    case thisFieldsErrors of
        [] ->
            Html.text ""

        error :: _ ->
            Html.Custom.error (Tuple.second error)


responseErrorView : Maybe String -> Html Msg
responseErrorView maybeError =
    case maybeError of
        Just error ->
            Html.Custom.error error

        Nothing ->
            Html.text ""



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
