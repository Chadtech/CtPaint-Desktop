module Page.Register
    exposing
        ( Model
        , Msg(..)
        , Problem(..)
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html
    exposing
        ( Attribute
        , Html
        , a
        , br
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
import Ports exposing (JsMsg(..), RegistrationPayload)
import Tos
import Tuple.Infix exposing ((&), (:=))
import Util
import Validate exposing (ifBlank)


-- TYPES --


type Model
    = Ready Fields
    | Success String
    | Fail Problem


type alias Fields =
    { name : String
    , email : String
    , emailConfirm : String
    , password : String
    , passwordConfirm : String
    , errors : List ( Field, String )
    , show : Bool
    , termsOfServiceView : Bool
    , agreesToTermsOfService : Bool
    }


type Field
    = Name
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



-- INIT --


init : Model
init =
    { name = ""
    , email = ""
    , emailConfirm = ""
    , password = ""
    , passwordConfirm = ""
    , errors = []
    , show = True
    , termsOfServiceView = False
    , agreesToTermsOfService = False
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


css : Stylesheet
css =
    [ Css.Elements.p
        [ Css.withClass Long
            [ width (px 180) ]
        ]
    , Css.Elements.input
        [ Css.withClass Long
            [ width (px 300) ]
        ]
    , Css.class Main
        [ width (px 480) ]
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
        [ margin4 (px 4) (px 0) (px 0) (px 0)
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
    Html.Custom.cardSolitary []
        [ Html.Custom.header
            { text = "register"
            , closability = Html.Custom.NotClosable
            }
        , Html.Custom.cardBody [] (viewContent model)
        ]


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
        , lock fields.agreesToTermsOfService

        -- This input is here, because without it
        -- the enter key does not cause submission
        , input
            [ Attr.type_ "submit"
            , Attr.hidden True
            ]
            []
        , Html.Custom.menuButton
            [ onClick SubmitClicked ]
            [ Html.text "submit" ]
        ]
    ]



-- COMPONENT HTML --


lock : Bool -> Html Msg
lock locked =
    form
        [ class [ Field, LockContainer ] ]
        [ input
            [ class [ Lock ]
            , lockedValue locked
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


lockedValue : Bool -> Attribute Msg
lockedValue locked =
    if locked then
        Attr.value "x"
    else
        Attr.value " "


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field [ class [ Long ] ]
        [ p [ class [ Long ] ] [ Html.text name ]
        , input
            (class [ Long ] :: attributes)
            []
        ]


errorView : List ( Field, String ) -> Field -> Html Msg
errorView errors field =
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
                (updateField field str >> Util.noCmd)
                model

        Succeeded email ->
            Success email & Cmd.none

        Failed problem ->
            Fail problem & Cmd.none

        TosAgreeClicked ->
            ifFields toggleTos model

        ReadTosClicked ->
            ifFields (setTermsOfServiceView True) model

        GoBackFromTosClicked ->
            ifFields (setTermsOfServiceView False) model


toggleTos : Fields -> ( Fields, Cmd Msg )
toggleTos fields =
    { fields
        | agreesToTermsOfService =
            not fields.agreesToTermsOfService
    }
        & Cmd.none


setTermsOfServiceView : Bool -> Fields -> ( Fields, Cmd Msg )
setTermsOfServiceView bool fields =
    { fields
        | termsOfServiceView = bool
    }
        & Cmd.none


ifFields : (Fields -> ( Fields, Cmd Msg )) -> Model -> ( Model, Cmd Msg )
ifFields fieldsChanger model =
    case model of
        Ready fields ->
            fieldsChanger fields
                |> Tuple.mapFirst Ready

        _ ->
            model & Cmd.none


attemptRegistration : Taco -> Fields -> ( Fields, Cmd Msg )
attemptRegistration taco fields =
    let
        errors =
            validate fields
    in
    if fields.agreesToTermsOfService && List.isEmpty errors then
        let
            cmd =
                { email = fields.email
                , name = fields.name
                , password = fields.password
                , browser = taco.config.browser
                }
                    |> Register
                    |> Ports.send
        in
        { fields
            | errors = errors
            , password = ""
            , passwordConfirm = ""
            , show = False
        }
            & cmd
    else
        { fields
            | errors = errors
            , password = ""
            , passwordConfirm = ""
        }
            & Cmd.none


updateField : Field -> String -> Fields -> Fields
updateField field str fields =
    case field of
        Name ->
            { fields | name = str }

        Email ->
            { fields | email = str }

        EmailConfirm ->
            { fields | emailConfirm = str }

        Password ->
            { fields | password = str }

        PasswordConfirm ->
            { fields | passwordConfirm = str }


handleFail : String -> Fields -> Fields
handleFail fail fields =
    case fail of
        "UsernameExistsException: User already exists" ->
            { fields
                | errors =
                    Email
                        & "Email is already registered to an account"
                        |> List.singleton
            }

        other ->
            { fields
                | errors =
                    [ Email & other ]
            }



-- VALIDATIONS --


validate : Fields -> List ( Field, String )
validate =
    [ .email >> ifBlank ( Email, "email field is required" )
    , .password >> ifBlank ( Password, "password field is required" )
    , .name >> ifBlank ( Name, "name field is required" )
    , passwordsMatch
    , passwordLongEnough
    , emailsMatch
    , atLeastOneUpperCaseInPassword
    , atLeastOneLowerCaseInPassword
    , validEmail
    ]
        |> Validate.all


validEmail : Fields -> List ( Field, String )
validEmail model =
    case String.split "@" model.email of
        "" :: _ ->
            invalidEmail

        local :: rest ->
            case rest of
                [ domain ] ->
                    separateDomain domain local

                _ ->
                    invalidEmail

        _ ->
            invalidEmail


separateDomain : String -> String -> List ( Field, String )
separateDomain domain local =
    case String.split "." domain of
        _ :: [ "" ] ->
            invalidEmail

        name :: [ extension ] ->
            let
                allAlphanumeric =
                    List.foldr
                        (onlyAlphaNumeric >> (&&))
                        True
                        [ local, name, extension ]
            in
            if allAlphanumeric then
                []
            else
                invalidEmail

        _ ->
            invalidEmail


invalidEmail : List ( Field, String )
invalidEmail =
    [ ( Email, "Please enter a valid email address" ) ]


onlyAlphaNumeric : String -> Bool
onlyAlphaNumeric =
    String.all isAlphanumeric


isAlphanumeric : Char -> Bool
isAlphanumeric char =
    String.contains (String.fromChar char) alphanumeric


alphanumeric : String
alphanumeric =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


atLeastOneLowerCaseInPassword : Fields -> List ( Field, String )
atLeastOneLowerCaseInPassword { password } =
    if password == String.toUpper password then
        [ ( Password, "Password must contain at least one lower case letter" ) ]
    else
        []


atLeastOneUpperCaseInPassword : Fields -> List ( Field, String )
atLeastOneUpperCaseInPassword { password } =
    if password == String.toLower password then
        [ ( Password, "Password must contain at least one upper case letter" ) ]
    else
        []


passwordLongEnough : Fields -> List ( Field, String )
passwordLongEnough { password } =
    if String.length password < 8 then
        [ ( Password, "Password must be at least 8 characters" ) ]
    else
        []


passwordsMatch : Fields -> List ( Field, String )
passwordsMatch { password, passwordConfirm } =
    if password == passwordConfirm then
        []
    else
        [ ( PasswordConfirm, "Passwords do not match" ) ]


emailsMatch : Fields -> List ( Field, String )
emailsMatch { email, emailConfirm } =
    if email == emailConfirm then
        []
    else
        [ ( EmailConfirm, "Emails do not match" ) ]
