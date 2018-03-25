module Page.ResetPassword
    exposing
        ( Model
        , Msg
        , css
        , failed
        , init
        , succeeded
        , update
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Helpers.Password
import Html exposing (Attribute, Html, a, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(ResetPassword))
import Route
import Tuple.Infix exposing ((&), (|&))
import Util


-- TYPES --


type alias Model =
    { email : String
    , code : String
    , state : State
    }


type State
    = Ready ReadyModel
    | Sending
    | Success
    | Fail Problem


type Problem
    = InvalidCode
    | Other String


type alias ReadyModel =
    { password : String
    , passwordConfirm : String
    , error : Maybe String
    , show : Bool
    }


type Field
    = Password
    | PasswordConfirm


type Msg
    = GoHomeClicked
    | FieldUpdated Field String
    | Submitted
    | SubmitClicked
    | Succeeded
    | Failed String
    | TryAgainClicked
    | LoginClicked


succeeded : Msg
succeeded =
    Succeeded


failed : String -> Msg
failed =
    Failed


init : String -> String -> Model
init email code =
    { email = email
    , code = code
    , state =
        { password = ""
        , passwordConfirm = ""
        , error = Nothing
        , show = True
        }
            |> Ready
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoHomeClicked ->
            model & Route.goTo Route.Landing

        FieldUpdated Password str ->
            ifReady model (updatePassword str)

        FieldUpdated PasswordConfirm str ->
            ifReady model (updatePasswordConfirm str)

        Submitted ->
            case model.state of
                Ready readyModel ->
                    resetPassword model readyModel

                _ ->
                    model & Cmd.none

        SubmitClicked ->
            case model.state of
                Ready readyModel ->
                    resetPassword model readyModel

                _ ->
                    model & Cmd.none

        Succeeded ->
            { model | state = Success }
                & Cmd.none

        Failed "ExpiredCodeException: Invalid code provided, please request a code again." ->
            setFail model InvalidCode & Cmd.none

        Failed other ->
            setFail model (Other other) & Cmd.none

        TryAgainClicked ->
            model & Route.goTo Route.ForgotPassword

        LoginClicked ->
            model & Route.goTo Route.Login


ifReady : Model -> (ReadyModel -> ( ReadyModel, Cmd Msg )) -> ( Model, Cmd Msg )
ifReady model f =
    case model.state of
        Ready readyModel ->
            f readyModel
                |> Tuple.mapFirst (setReady model)

        _ ->
            model & Cmd.none


setFail : Model -> Problem -> Model
setFail model problem =
    { model | state = Fail problem }


setReady : Model -> ReadyModel -> Model
setReady model readyModel =
    { model | state = Ready readyModel }


updatePassword : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updatePassword str model =
    { model | password = str } & Cmd.none


updatePasswordConfirm : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updatePasswordConfirm str model =
    { model | passwordConfirm = str } & Cmd.none


resetPassword : Model -> ReadyModel -> ( Model, Cmd Msg )
resetPassword model readyModel =
    case validatePassword readyModel of
        Nothing ->
            ResetPassword
                model.email
                model.code
                readyModel.password
                |> Ports.send
                |& { model | state = Sending }

        Just error ->
            { model
                | state =
                    { readyModel | error = Just error }
                        |> Ready
            }
                & Cmd.none


validatePassword : ReadyModel -> Maybe String
validatePassword { password, passwordConfirm } =
    Helpers.Password.validate password passwordConfirm



-- STYLES --


type Class
    = Long
    | Main
    | Error
    | Button
    | MarginTop


fieldTextWidth : Float
fieldTextWidth =
    180


cardWidth : Float
cardWidth =
    410


css : Stylesheet
css =
    [ Css.Elements.p
        [ Css.withClass Long
            [ width (px fieldTextWidth) ]
        ]
    , Css.Elements.input
        [ Css.withClass Long
            [ width (px (cardWidth - fieldTextWidth)) ]
        ]
    , Css.class Main
        [ width (px cardWidth) ]
    , Css.class Button
        [ margin auto
        , display table
        , withClass MarginTop
            [ marginTop (px 8) ]
        ]
    , Css.class Error
        [ marginBottom (px 8) ]
    ]
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
    , Html.Custom.cardBody [] (body model)
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> Html.Custom.background []


body : Model -> List (Html Msg)
body model =
    case model.state of
        Ready readyModel ->
            readyBody readyModel

        Sending ->
            sendingBody

        Success ->
            successBody

        Fail problem ->
            failBody problem


readyBody : ReadyModel -> List (Html Msg)
readyBody model =
    let
        value_ : String -> Attribute Msg
        value_ =
            Attrs.value << Util.showIf model.show
    in
    [ form
        [ class [ Main ]
        , onSubmit Submitted
        ]
        [ field
            "password"
            [ value_ model.password
            , Attrs.type_ "password"
            , onInput_ Password
            ]
        , field
            "type it again"
            [ value_ model.passwordConfirm
            , Attrs.type_ "password"
            , onInput_ PasswordConfirm
            ]
        , input
            [ Attrs.type_ "submit"
            , Attrs.hidden True
            ]
            []
        , errorView model.error
        , a
            [ class [ Button ]
            , onClick SubmitClicked
            ]
            [ Html.text "reset" ]
        ]
    ]


sendingBody : List (Html Msg)
sendingBody =
    [ Html.Custom.spinner ]


successBody : List (Html Msg)
successBody =
    [ p
        []
        [ Html.text successText ]
    , a
        [ class [ Button, MarginTop ]
        , onClick LoginClicked
        ]
        [ Html.text "go to login" ]
    ]


successText : String
successText =
    """
    Great. It worked. Your password has been reset.
    Now go back to the login in page and use your
    new password.
    """


failBody : Problem -> List (Html Msg)
failBody problem =
    [ p
        []
        [ Html.text (failMsg problem) ]
    , failButton problem
    ]


failButton : Problem -> Html Msg
failButton problem =
    case problem of
        InvalidCode ->
            a
                [ class [ Button, MarginTop ]
                , onClick TryAgainClicked
                ]
                [ Html.text "try again" ]

        Other _ ->
            Html.text ""


failMsg : Problem -> String
failMsg problem =
    case problem of
        InvalidCode ->
            "The reset code was invalid. Sorry. Please try again."

        Other _ ->
            "Something went wrong, I dont know what. Sorry. Please try again."


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field
        [ class [ Long ] ]
        [ p
            [ class [ Long ] ]
            [ Html.text name ]
        , input
            (class [ Long ] :: attributes)
            []
        ]


errorView : Maybe String -> Html Msg
errorView maybeError =
    case maybeError of
        Just error ->
            Html.Custom.error
                [ class [ Error ] ]
                error

        Nothing ->
            Html.text ""


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
