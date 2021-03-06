module Page.ResetPassword exposing
    ( Model
    , Msg
    , css
    , failed
    , init
    , succeeded
    , track
    , update
    , view
    )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Helpers.Password
import Html exposing (Attribute, Html, a, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(ResetPassword))
import Return2 as R2
import Route
import Util



-- TYPES --


type Model
    = Ready ReadyModel
    | Sending
    | Success
    | Fail Problem


type Problem
    = InvalidCode
    | Other String


type alias ReadyModel =
    { email : String
    , code : String
    , password : String
    , passwordConfirm : String
    , error : Maybe String
    , show : Bool
    }


type Field
    = Email
    | Code
    | Password
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


init : Model
init =
    { email = ""
    , code = ""
    , password = ""
    , passwordConfirm = ""
    , error = Nothing
    , show = True
    }
        |> Ready



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoHomeClicked ->
            Route.goTo Route.Landing
                |> R2.withModel model

        FieldUpdated Email str ->
            ifReady model (updateEmail str)

        FieldUpdated Code str ->
            ifReady model (updateCode str)

        FieldUpdated Password str ->
            ifReady model (updatePassword str)

        FieldUpdated PasswordConfirm str ->
            ifReady model (updatePasswordConfirm str)

        Submitted ->
            submit model

        SubmitClicked ->
            submit model

        Succeeded ->
            Success
                |> R2.withNoCmd

        Failed err ->
            handleError model err

        TryAgainClicked ->
            Route.goTo Route.ForgotPassword
                |> R2.withModel model

        LoginClicked ->
            Route.goTo Route.Login
                |> R2.withModel model


handleError : Model -> String -> ( Model, Cmd Msg )
handleError model err =
    case err of
        "ExpiredCodeException: Invalid code provided, please request a code again." ->
            InvalidCode
                |> Fail
                |> R2.withNoCmd

        _ ->
            err
                |> Other
                |> Fail
                |> R2.withNoCmd


ifReady : Model -> (ReadyModel -> ( ReadyModel, Cmd Msg )) -> ( Model, Cmd Msg )
ifReady model f =
    case model of
        Ready readyModel ->
            f readyModel
                |> Tuple.mapFirst Ready

        _ ->
            model
                |> R2.withNoCmd


updateEmail : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updateEmail str model =
    { model | email = str }
        |> R2.withNoCmd


updateCode : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updateCode str model =
    { model | code = str }
        |> R2.withNoCmd


updatePassword : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updatePassword str model =
    { model | password = str }
        |> R2.withNoCmd


updatePasswordConfirm : String -> ReadyModel -> ( ReadyModel, Cmd Msg )
updatePasswordConfirm str model =
    { model | passwordConfirm = str }
        |> R2.withNoCmd


submit : Model -> ( Model, Cmd Msg )
submit model =
    case model of
        Ready readyModel ->
            resetPassword readyModel

        _ ->
            model
                |> R2.withNoCmd


resetPassword : ReadyModel -> ( Model, Cmd Msg )
resetPassword readyModel =
    case validatePassword readyModel of
        Nothing ->
            ResetPassword
                readyModel.email
                readyModel.code
                readyModel.password
                |> Ports.send
                |> R2.withModel Sending

        Just error ->
            { readyModel | error = Just error }
                |> Ready
                |> R2.withNoCmd


validatePassword : ReadyModel -> Maybe String
validatePassword { password, passwordConfirm } =
    Helpers.Password.validate password passwordConfirm



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        GoHomeClicked ->
            Tracking.noProps "go-home click"

        FieldUpdated _ _ ->
            Nothing

        Submitted ->
            Tracking.noProps "submit enter press"

        SubmitClicked ->
            Tracking.noProps "submit click"

        Succeeded ->
            Tracking.response Nothing

        Failed err ->
            Tracking.response (Just err)

        TryAgainClicked ->
            Tracking.noProps "try-again click"

        LoginClicked ->
            Tracking.noProps "login click"



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
    case model of
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
            "email"
            [ value_ model.email
            , onInput_ Email
            ]
        , field
            "code"
            [ value_ model.code
            , onInput_ Code
            ]
        , field
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
            (baseAttrs ++ attributes)
            []
        ]


baseAttrs : List (Attribute Msg)
baseAttrs =
    [ class [ Long ]
    , Attrs.spellcheck False
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
