module Page.Register exposing (..)

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
        , text
        )
import Html.Attributes exposing (class, hidden, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(..), RegistrationPayload)
import Styles exposing (Classes(..))
import Util exposing ((&), (:=), showIf)
import Validate exposing (ifBlank)


-- TYPES --


type Model
    = Fields FieldsModel
    | Success String
    | Fail Problem


type alias FieldsModel =
    { username : String
    , email : String
    , emailConfirm : String
    , password : String
    , passwordConfirm : String
    , errors : List ( Field, String )
    , show : Bool
    }


type Field
    = Username
    | Email
    | EmailConfirm
    | Password
    | PasswordConfirm


type Problem
    = CouldntDecodeSuccess
    | CouldntDecodeFail
    | Other String


type Msg
    = UpdateField Field String
    | AttemptRegistration
    | Succeeded String
    | Failed Problem



-- INIT --


init : Model
init =
    { username = ""
    , email = ""
    , emailConfirm = ""
    , password = ""
    , passwordConfirm = ""
    , errors = []
    , show = True
    }
        |> Fields



-- VIEW --


{ class } =
    Styles.helpers


view : Model -> Html Msg
view model =
    div
        [ class [ Card, Solitary ] ]
        [ div
            [ class [ Header ] ]
            [ p [] [ text "register" ] ]
        , div
            [ class [ Body ] ]
            (viewContent model)
        ]


viewContent : Model -> List (Html Msg)
viewContent model =
    case model of
        Fields fields ->
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
        [ text problem ]
    ]


successView : String -> List (Html Msg)
successView email =
    [ p
        []
        [ text "Success! Your account is registered" ]
    , br [] []
    , p
        []
        [ text ("A verification email was sent to " ++ email) ]
    ]


registeringView : FieldsModel -> List (Html Msg)
registeringView fieldsModel =
    let
        value_ : String -> Attribute Msg
        value_ =
            value << showIf fieldsModel.show

        errorView_ : Field -> Html Msg
        errorView_ =
            errorView fieldsModel.errors
    in
    [ form
        [ onSubmit AttemptRegistration ]
        [ field
            "username"
            [ value_ fieldsModel.username
            , onInput_ Username
            ]
        , errorView_ Username
        , field
            "email"
            [ value_ fieldsModel.email
            , onInput_ Email
            ]
        , errorView_ Email
        , field
            "type it again"
            [ value_ fieldsModel.emailConfirm
            , onInput_ EmailConfirm
            ]
        , errorView_ EmailConfirm
        , field
            "password"
            [ value_ fieldsModel.password
            , type_ "password"
            , onInput_ Password
            ]
        , errorView_ Password
        , field
            "type it again"
            [ value_ fieldsModel.passwordConfirm
            , type_ "password"
            , onInput_ PasswordConfirm
            ]
        , errorView_ PasswordConfirm

        -- This input is here, because without it
        -- the enter key does not cause submission
        , input
            [ type_ "submit"
            , hidden True
            ]
            []
        , a
            [ class [ Submit ]
            , onClick AttemptRegistration
            ]
            [ text "submit" ]
        ]
    ]



-- COMPONENT HTML --


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    div
        [ class [ Field ] ]
        [ p [ class [ Long ] ] [ text name ]
        , input
            (class [ Long ] :: attributes)
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
            div
                [ class [ Error ] ]
                [ p
                    []
                    [ text (Tuple.second error) ]
                ]



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    UpdateField >> onInput



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AttemptRegistration ->
            case model of
                Fields fields ->
                    attemptRegistration fields

                _ ->
                    model & Cmd.none

        UpdateField field str ->
            case model of
                Fields fieldsModel ->
                    updateField field str fieldsModel
                        |> Fields
                        & Cmd.none

                _ ->
                    model & Cmd.none

        Succeeded email ->
            Success email & Cmd.none

        Failed problem ->
            Fail problem & Cmd.none


attemptRegistration : FieldsModel -> ( Model, Cmd Msg )
attemptRegistration fields =
    let
        errors =
            validate fields
    in
    if List.isEmpty errors then
        let
            newFields =
                { fields
                    | errors = errors
                    , password = ""
                    , passwordConfirm = ""
                    , show = False
                }

            cmd =
                { email = fields.email
                , username = fields.username
                , password = fields.password
                }
                    |> Register
                    |> Ports.send
        in
        Fields newFields & cmd
    else
        { fields
            | errors = errors
            , password = ""
            , passwordConfirm = ""
        }
            |> Fields
            & Cmd.none


updateField : Field -> String -> FieldsModel -> FieldsModel
updateField field str fieldsModel =
    case field of
        Username ->
            { fieldsModel | username = str }

        Email ->
            { fieldsModel | email = str }

        EmailConfirm ->
            { fieldsModel | emailConfirm = str }

        Password ->
            { fieldsModel | password = str }

        PasswordConfirm ->
            { fieldsModel | passwordConfirm = str }


handleFail : String -> FieldsModel -> FieldsModel
handleFail fail fieldsModel =
    case fail of
        "UsernameExistsException: User already exists" ->
            { fieldsModel
                | errors =
                    Email
                        & "Email is already registered to an account"
                        |> List.singleton
            }

        other ->
            { fieldsModel
                | errors =
                    [ Email & other ]
            }



-- VALIDATIONS --


validate : FieldsModel -> List ( Field, String )
validate =
    Validate.all
        [ .email >> ifBlank ( Email, "Email field is required" )
        , .password >> ifBlank ( Password, "Password field is required" )
        , .username >> ifBlank ( Username, "Username field is required" )
        , passwordsMatch
        , passwordLongEnough
        , emailsMatch
        , atLeastOneUpperCaseInPassword
        , atLeastOneLowerCaseInPassword
        , validEmail
        ]


validEmail : FieldsModel -> List ( Field, String )
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


atLeastOneLowerCaseInPassword : FieldsModel -> List ( Field, String )
atLeastOneLowerCaseInPassword { password } =
    if password == String.toUpper password then
        [ ( Password, "Password must contain at least one lower case letter" ) ]
    else
        []


atLeastOneUpperCaseInPassword : FieldsModel -> List ( Field, String )
atLeastOneUpperCaseInPassword { password } =
    if password == String.toLower password then
        [ ( Password, "Password must contain at least one upper case letter" ) ]
    else
        []


passwordLongEnough : FieldsModel -> List ( Field, String )
passwordLongEnough { password } =
    if String.length password < 8 then
        [ ( Password, "Password must be at least 8 characters" ) ]
    else
        []


passwordsMatch : FieldsModel -> List ( Field, String )
passwordsMatch { password, passwordConfirm } =
    if password == passwordConfirm then
        []
    else
        [ ( PasswordConfirm, "Passwords do not match" ) ]


emailsMatch : FieldsModel -> List ( Field, String )
emailsMatch { email, emailConfirm } =
    if email == emailConfirm then
        []
    else
        [ ( EmailConfirm, "Emails do not match" ) ]
