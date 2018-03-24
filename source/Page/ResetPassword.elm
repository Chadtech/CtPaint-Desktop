module Page.ResetPassword
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(ResetPassword))
import Route
import Tuple.Infix exposing ((&))
import Util


-- TYPES --


type Model
    = Ready ReadyModel
    | Sending
    | Success
    | Fail


type alias ReadyModel =
    { email : String
    , code : String
    , password : String
    , passwordConfirm : String
    , errors : List String
    , show : Bool
    }


type Field
    = Password
    | PasswordConfirm


type Msg
    = GoHomeClicked
    | FieldUpdated Field String
    | Submitted


init : String -> String -> Model
init email code =
    { email = email
    , code = code
    , password = ""
    , passwordConfirm = ""
    , errors = []
    , show = True
    }
        |> Ready



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoHomeClicked ->
            model & Route.goTo Route.Landing

        FieldUpdated Password str ->
            case model of
                Ready readyModel ->
                    { readyModel | password = str }
                        |> Ready
                        & Cmd.none

                _ ->
                    model & Cmd.none

        FieldUpdated PasswordConfirm str ->
            case model of
                Ready readyModel ->
                    { readyModel | passwordConfirm = str }
                        |> Ready
                        & Cmd.none

                _ ->
                    model & Cmd.none

        Submitted ->
            case model of
                Ready readyModel ->
                    resetPassword readyModel

                _ ->
                    model & Cmd.none


resetPassword : ReadyModel -> ( Model, Cmd Msg )
resetPassword model =
    Ready model & Cmd.none



-- STYLES --


type Class
    = Long
    | Main


fieldTextWidth : Float
fieldTextWidth =
    180


cardWidth : Float
cardWidth =
    530


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

        Fail ->
            failBody


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
        ]
    ]


sendingBody : List (Html Msg)
sendingBody =
    [ Html.Custom.spinner ]


successBody : List (Html Msg)
successBody =
    []


failBody : List (Html Msg)
failBody =
    []


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


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
