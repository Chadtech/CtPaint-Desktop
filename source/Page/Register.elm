module Page.Register
    exposing
        ( Model
        , Msg(..)
        , Problem(..)
        , css
        , init
        , track
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Helpers.Password
import Html
    exposing
        ( Attribute
        , Html
        , a
        , br
        , form
        , input
        , p
        , span
        )
import Html.Attributes as Attr
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode as Encode
import Json.Encode.Extra as Encode
import Ports exposing (JsMsg(..))
import Return2 as R2
import Tos
import Util exposing (def)
import Validate exposing (ifBlank)


-- TYPES --


type Model
    = Ready Fields
    | Success String
    | Fail Problem


type alias Fields =
    { name : String
    , profilePicUrl : String
    , email : String
    , emailConfirm : String
    , password : String
    , passwordConfirm : String
    , errors : List ( Field, String )
    , generalError : Maybe String
    , show : Bool
    , termsOfServiceView : Bool
    , agreesToTermsOfService : Bool
    , isOkayWithEmails : Bool
    }


type Field
    = Name
    | ProfilePicUrl
    | Email
    | EmailConfirm
    | Password
    | PasswordConfirm


type Problem
    = CouldntDecodeSuccess
    | CouldntDecodeFail
    | Other String


type Msg
    = FieldUpdated Field String
    | Submitted
    | SubmitClicked
    | Succeeded String
    | Failed Problem
    | TosAgreeClicked
    | ReadTosClicked
    | GoBackFromTosClicked
    | EmailAgreeClicked



-- INIT --


init : Model
init =
    { name = ""
    , profilePicUrl = ""
    , email = ""
    , emailConfirm = ""
    , password = ""
    , passwordConfirm = ""
    , errors = []
    , generalError = Nothing
    , show = True
    , termsOfServiceView = False
    , agreesToTermsOfService = False
    , isOkayWithEmails = False
    }
        |> Ready



-- STYLES --


type Class
    = Long
    | Main
    | Field
    | Lock
    | LockContainer
    | TosLink
    | TosTitle
    | Submit


cardWidth : Float
cardWidth =
    530


fieldTextWidth : Float
fieldTextWidth =
    180


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
    , Css.class Submit
        [ marginTop (px 0)
        , display table
        , margin auto
        ]
    , Css.class Main
        [ width (px cardWidth) ]
    , Css.class LockContainer
        [ display inlineBlock
        , children
            [ Css.Elements.p
                [ display inlineBlock
                , marginLeft (px 8)
                ]
            ]
        ]
    , Css.class Lock
        [ height (px 24)
        , cursor pointer
        , children
            [ Css.Elements.input
                [ width auto ]
            ]
        ]
    , Css.class Field
        [ marginBottom (px 8)
        , children
            [ Css.Elements.input
                [ width (px 80)
                , withClass Lock
                    [ width (px 24) ]
                ]
            ]
        ]
    , Css.class TosLink
        [ color Ct.important0
        , cursor pointer
        , marginLeft (px 11)
        , hover
            [ color Ct.important1 ]
        ]
    , Css.class TosTitle
        [ marginBottom (px 8) ]
    ]
        |> namespace registerNamespace
        |> stylesheet


registerNamespace : String
registerNamespace =
    Html.Custom.makeNamespace "Register"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace registerNamespace


view : Model -> Html Msg
view model =
    [ Html.Custom.header
        { text = "register"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody [] (viewContent model)
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> Html.Custom.background []


viewContent : Model -> List (Html Msg)
viewContent model =
    case model of
        Ready fields ->
            registeringView fields

        Success email ->
            successView email

        Fail CouldntDecodeSuccess ->
            "I think it worked, but something went wrong. Check your email and you probably got a verification link"
                |> failView

        Fail CouldntDecodeFail ->
            "Sorry, something broke, and I dont know what"
                |> failView

        Fail (Other str) ->
            failView str


failView : String -> List (Html Msg)
failView problem =
    [ p
        []
        [ Html.text problem ]
    ]


successView : String -> List (Html Msg)
successView email =
    [ p
        []
        [ Html.text "Success! Your account is registered" ]
    , br [] []
    , p
        []
        [ Html.text ("A verification email was sent to " ++ email) ]
    ]


registeringView : Fields -> List (Html Msg)
registeringView fields =
    if fields.termsOfServiceView then
        termsOfServiceView
    else
        fieldsView fields


termsOfServiceView : List (Html Msg)
termsOfServiceView =
    [ p
        [ class [ TosTitle ] ]
        [ Html.text "CtPaint Terms of Service" ]
    , Tos.view
    , Html.Custom.menuButton
        [ onClick GoBackFromTosClicked ]
        [ Html.text "go back" ]
    ]


fieldsView : Fields -> List (Html Msg)
fieldsView fields =
    let
        value_ : String -> Attribute Msg
        value_ =
            Attr.value << Util.showIf fields.show

        errorView_ : Field -> Html Msg
        errorView_ =
            errorView fields.errors
    in
    [ form
        [ class [ Main ]
        , onSubmit Submitted
        ]
        [ field
            "name"
            [ value_ fields.name
            , onInput_ Name
            ]
        , errorView_ Name
        , field
            "profile pic url"
            [ value_ fields.profilePicUrl
            , onInput_ ProfilePicUrl
            ]
        , field
            "email"
            [ value_ fields.email
            , onInput_ Email
            ]
        , errorView_ Email
        , field
            "type it again"
            [ value_ fields.emailConfirm
            , onInput_ EmailConfirm
            ]
        , errorView_ EmailConfirm
        , field
            "password"
            [ value_ fields.password
            , Attr.type_ "password"
            , onInput_ Password
            ]
        , errorView_ Password
        , field
            "type it again"
            [ value_ fields.passwordConfirm
            , Attr.type_ "password"
            , onInput_ PasswordConfirm
            ]
        , errorView_ PasswordConfirm
        , tosCheck fields.agreesToTermsOfService
        , emailCheck fields.isOkayWithEmails
        , Util.viewMaybe
            fields.generalError
            (Html.Custom.error [])

        -- This input is here, because without it
        -- the enter key does not cause submission
        , input
            [ Attr.type_ "submit"
            , Attr.hidden True
            ]
            []
        , a
            [ class [ Submit ]
            , onClick SubmitClicked
            ]
            [ Html.text "submit" ]
        ]
    ]



-- COMPONENT HTML --


emailCheck : Bool -> Html Msg
emailCheck checked =
    form
        [ class [ Field, LockContainer ] ]
        [ input
            [ class [ Lock ]
            , checkedValue checked
            , onClick EmailAgreeClicked
            , Attr.type_ "button"
            ]
            []
        , p
            []
            [ Html.text "you can email me sometimes about CtPaint news" ]
        ]


tosCheck : Bool -> Html Msg
tosCheck checked =
    form
        [ class [ Field, LockContainer ] ]
        [ input
            [ class [ Lock ]
            , checkedValue checked
            , onClick TosAgreeClicked
            , Attr.type_ "button"
            ]
            []
        , p
            []
            [ Html.text "I agree to the"
            , span
                [ class [ TosLink ]
                , onClick ReadTosClicked
                ]
                [ Html.text "CtPaint terms of service" ]
            ]
        ]


checkedValue : Bool -> Attribute Msg
checkedValue checked =
    if checked then
        Attr.value "x"
    else
        Attr.value " "


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field [ class [ Long ] ]
        [ p [ class [ Long ] ] [ Html.text name ]
        , input
            (inputAttrs attributes)
            []
        ]


inputAttrs : List (Attribute Msg) -> List (Attribute Msg)
inputAttrs attrs =
    [ class [ Long ]
    , Attr.spellcheck False
    ]
        ++ attrs


errorView : List ( Field, String ) -> Field -> Html Msg
errorView errors field =
    case List.filter (Tuple.first >> (==) field) errors of
        [] ->
            Html.text ""

        error :: _ ->
            error
                |> Tuple.second
                |> Html.Custom.error []



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        Submitted ->
            ifFields (attemptRegistration taco) model

        SubmitClicked ->
            ifFields (attemptRegistration taco) model

        FieldUpdated field str ->
            ifFields
                (updateField field str >> R2.withNoCmd)
                model

        Succeeded email ->
            Success email
                |> R2.withNoCmd

        Failed problem ->
            Fail problem
                |> R2.withNoCmd

        TosAgreeClicked ->
            ifFields toggleTos model

        ReadTosClicked ->
            ifFields (setTermsOfServiceView True) model

        GoBackFromTosClicked ->
            ifFields (setTermsOfServiceView False) model

        EmailAgreeClicked ->
            ifFields toggleEmail model


toggleEmail : Fields -> ( Fields, Cmd Msg )
toggleEmail fields =
    { fields
        | isOkayWithEmails =
            not fields.isOkayWithEmails
    }
        |> R2.withNoCmd


toggleTos : Fields -> ( Fields, Cmd Msg )
toggleTos fields =
    { fields
        | agreesToTermsOfService =
            not fields.agreesToTermsOfService
    }
        |> R2.withNoCmd


setTermsOfServiceView : Bool -> Fields -> ( Fields, Cmd Msg )
setTermsOfServiceView bool fields =
    { fields
        | termsOfServiceView = bool
    }
        |> R2.withNoCmd


ifFields : (Fields -> ( Fields, Cmd Msg )) -> Model -> ( Model, Cmd Msg )
ifFields fieldsChanger model =
    case model of
        Ready fields ->
            fieldsChanger fields
                |> Tuple.mapFirst Ready

        _ ->
            model |> R2.withNoCmd


attemptRegistration : Taco -> Fields -> ( Fields, Cmd Msg )
attemptRegistration taco fields =
    let
        errors =
            validate fields
    in
    if not fields.agreesToTermsOfService then
        { fields
            | generalError =
                Just "you have to agree to the terms of service to use this site"
        }
            |> R2.withNoCmd
    else if List.isEmpty errors then
        { fields
            | errors = errors
            , password = ""
            , passwordConfirm = ""
            , show = False
        }
            |> R2.withCmd (registerCmd taco fields)
    else
        { fields
            | errors = errors
            , password = ""
            , passwordConfirm = ""
        }
            |> R2.withNoCmd


registerCmd : Taco -> Fields -> Cmd Msg
registerCmd taco fields =
    { email = fields.email
    , profilePicUrl = fields.profilePicUrl
    , name = fields.name
    , password = fields.password
    , browser = taco.config.browser
    , emailable = fields.isOkayWithEmails
    }
        |> Register
        |> Ports.send


updateField : Field -> String -> Fields -> Fields
updateField field str fields =
    case field of
        Name ->
            { fields | name = str }

        ProfilePicUrl ->
            { fields | profilePicUrl = str }

        Email ->
            { fields | email = str }

        EmailConfirm ->
            { fields | emailConfirm = str }

        Password ->
            { fields | password = str }

        PasswordConfirm ->
            { fields | passwordConfirm = str }



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        Submitted ->
            Tracking.noProps "submit enter press"

        SubmitClicked ->
            Tracking.noProps "submit click"

        FieldUpdated _ _ ->
            Nothing

        Succeeded _ ->
            trackResponse Nothing

        Failed problem ->
            problem
                |> toString
                |> Just
                |> trackResponse

        TosAgreeClicked ->
            Tracking.noProps "tos-agree click"

        ReadTosClicked ->
            Tracking.noProps "read-tos click"

        GoBackFromTosClicked ->
            Tracking.noProps "go-back-from-tos click"

        EmailAgreeClicked ->
            Tracking.noProps "email-agree click"


trackResponse : Maybe String -> Maybe Tracking.Event
trackResponse maybeError =
    [ maybeError
        |> Encode.maybe Encode.string
        |> def "error"
    ]
        |> def "response"
        |> Just



-- VALIDATIONS --


validate : Fields -> List ( Field, String )
validate =
    [ .email >> ifBlank ( Email, "email field is required" )
    , .name >> ifBlank ( Name, "name field is required" )
    , validPassword
    , validEmail
    , emailsMatch
    ]
        |> Validate.all


validEmail : Fields -> List ( Field, String )
validEmail { email } =
    if Util.isValidEmail email then
        []
    else
        [ ( Email, "Please enter a valid email address" ) ]


validPassword : Fields -> List ( Field, String )
validPassword { password, passwordConfirm } =
    case Helpers.Password.validate password passwordConfirm of
        Nothing ->
            []

        Just error ->
            [ ( Password, error ) ]


emailsMatch : Fields -> List ( Field, String )
emailsMatch { email, emailConfirm } =
    if email == emailConfirm then
        []
    else
        [ ( EmailConfirm, "Emails do not match" ) ]
