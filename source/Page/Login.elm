module Page.Login
    exposing
        ( Model
        , Msg(LoginFailed)
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html
    exposing
        ( Attribute
        , Html
        , a
        , div
        , form
        , input
        , p
        , span
        )
import Html.Attributes as Attr
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(..))
import Return2 as R2
import Route
import Tracking
    exposing
        ( Event
            ( PageLoginClick
            , PageLoginEnterPress
            , PageLoginFail
            , PageLoginForgotPasswordClick
            )
        )
import Validate exposing (ifBlank)


type alias Model =
    { email : String
    , password : String
    , errors : List ( Field, String )
    , responseError : Maybe String
    , state : State
    }


type State
    = Ready
    | LoggingIn


type Field
    = Email
    | Password


type Msg
    = FieldUpdated Field String
    | Submitted
    | LoginClicked
    | LoginFailed String
    | ForgotPasswordClicked



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , errors = []
    , responseError = Nothing
    , state = Ready
    }



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        FieldUpdated Email str ->
            { model | email = str }
                |> R2.withNoCmd

        FieldUpdated Password str ->
            { model | password = str }
                |> R2.withNoCmd

        Submitted ->
            attemptLogin model
                |> R2.addCmd
                    (Ports.track taco PageLoginEnterPress)

        LoginClicked ->
            attemptLogin model
                |> R2.addCmd
                    (Ports.track taco PageLoginClick)

        LoginFailed err ->
            PageLoginFail err
                |> Ports.track taco
                |> R2.withModel
                    { model
                        | responseError =
                            Just (responseError err)
                        , state = Ready
                    }

        ForgotPasswordClicked ->
            [ Route.goTo Route.ForgotPassword
            , Ports.track taco PageLoginForgotPasswordClick
            ]
                |> Cmd.batch
                |> R2.withModel model


attemptLogin : Model -> ( Model, Cmd Msg )
attemptLogin model =
    let
        errors =
            validate model

        noErrors =
            List.isEmpty errors
    in
    { model
        | errors = errors
        , password = ""
        , state =
            if noErrors then
                LoggingIn
            else
                Ready
        , responseError = Nothing
    }
        |> R2.withCmd (attemptLoginCmd model noErrors)


attemptLoginCmd : Model -> Bool -> Cmd Msg
attemptLoginCmd model noErrors =
    if noErrors then
        Login model.email model.password
            |> Ports.send
    else
        Cmd.none


responseError : String -> String
responseError err =
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
    | ForgotLink
    | Body


css : Stylesheet
css =
    [ Css.class Text
        [ width (px 120) ]
    , Css.class Long
        [ width (px 300) ]
    , Css.class Body
        [ width (px 400) ]
    , Css.class ForgotLink
        [ color Ct.important0
        , hover
            [ cursor pointer
            , color Ct.important1
            ]
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
    [ Html.Custom.header
        { text = "login"
        , closability = Html.Custom.NotClosable
        }
    , model
        |> viewBody
        |> Html.Custom.cardBody
            [ class [ Body ] ]
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> Html.Custom.background []


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.state of
        Ready ->
            readyView model

        LoggingIn ->
            loggingInView model


loggingInView : Model -> List (Html Msg)
loggingInView model =
    [ Html.Custom.spinner ]


readyView : Model -> List (Html Msg)
readyView model =
    let
        errorView_ : Field -> Html Msg
        errorView_ =
            fieldErrorView model.errors
    in
    [ form
        [ onSubmit Submitted ]
        [ field "email"
            [ Attr.value model.email
            , onInput_ Email
            , Attr.spellcheck False
            ]
        , errorView_ Email
        , field "password"
            [ Attr.value model.password
            , Attr.type_ "password"
            , Attr.spellcheck False
            , onInput_ Password
            ]
        , responseErrorView model.responseError
        , input
            [ Attr.type_ "submit"
            , Attr.hidden True
            ]
            []
        , p
            []
            [ span
                [ class [ ForgotLink ]
                , onClick ForgotPasswordClicked
                ]
                [ Html.text "I forgot my password" ]
            ]
        , Html.Custom.menuButton
            [ onClick LoginClicked ]
            [ Html.text "log in" ]
        ]
    ]



-- COMPONENT HTML --


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field []
        [ p [ class [ Text ] ] [ Html.text name ]
        , input (class [ Long ] :: attributes) []
        ]


fieldErrorView : List ( Field, String ) -> Field -> Html Msg
fieldErrorView errors field =
    case thisFieldsErrors errors field of
        [] ->
            Html.text ""

        ( _, error ) :: _ ->
            error
                |> Html.Custom.error []


thisFieldsErrors : List ( Field, String ) -> Field -> List ( Field, String )
thisFieldsErrors errors field =
    List.filter (Tuple.first >> (==) field) errors


responseErrorView : Maybe String -> Html Msg
responseErrorView maybeError =
    case maybeError of
        Just error ->
            Html.Custom.error [] error

        Nothing ->
            Html.text ""



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
