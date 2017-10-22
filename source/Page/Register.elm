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
import Json.Encode as Encode
import Ports exposing (JsMsg(..), RegistrationPayload)
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
    , showFields : Bool
    , registrationPending : Bool
    }


type Field
    = Username
    | Email
    | EmailConfirm
    | Password
    | PasswordConfirm


type Problem
    = Unknown


type Msg
    = UpdateField Field String
    | AttemptRegistration



-- INIT --


init : Model
init =
    { username = ""
    , email = ""
    , emailConfirm = ""
    , password = ""
    , passwordConfirm = ""
    , errors = []
    , showFields = True
    , registrationPending = False
    }
        |> Fields



-- VIEW --


view : Model -> Html Msg
view model =
    case model of
        Fields fieldsModel ->
            registeringView fieldsModel

        Success email ->
            successView email

        Fail problem ->
            Html.text "fail"


successView : String -> Html Msg
successView email =
    div
        [ class "card solitary register-success" ]
        [ p
            []
            [ text "Success! Your account is registered" ]
        , br [] []
        , p
            []
            [ text ("A verification email was sent to " ++ email) ]
        ]


registeringView : FieldsModel -> Html Msg
registeringView fieldsModel =
    let
        value_ : String -> Attribute Msg
        value_ =
            value << showIf fieldsModel.showFields

        errorView_ : Field -> Html Msg
        errorView_ =
            errorView fieldsModel.errors
    in
    div
        [ class "card solitary register" ]
        [ form
            [ onSubmit AttemptRegistration ]
            [ p [] [ text "Account Registration" ]
            , field
                "Username"
                [ value_ fieldsModel.username
                , onInput_ Username
                ]
            , errorView_ Username
            , field
                "Email"
                [ value_ fieldsModel.email
                , onInput_ Email
                ]
            , errorView_ Email
            , field
                "Type it again"
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
                "Type it again"
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
                [ onClick AttemptRegistration ]
                [ text "submit" ]
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
            div
                [ class "error-zone" ]
                [ p
                    []
                    [ text (Tuple.second error) ]
                ]



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    UpdateField >> onInput



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case model of
        Fields fieldsModel ->
            updateFields msg fieldsModel
                |> Tuple.mapFirst Fields

        _ ->
            model & Cmd.none


updateFields : Msg -> FieldsModel -> ( FieldsModel, Cmd msg )
updateFields msg fieldsModel =
    case msg of
        UpdateField Username str ->
            { fieldsModel | username = str } & Cmd.none

        UpdateField Email str ->
            { fieldsModel | email = str } & Cmd.none

        UpdateField EmailConfirm str ->
            { fieldsModel | emailConfirm = str } & Cmd.none

        UpdateField Password str ->
            { fieldsModel | password = str } & Cmd.none

        UpdateField PasswordConfirm str ->
            { fieldsModel | passwordConfirm = str } & Cmd.none

        AttemptRegistration ->
            let
                errors =
                    validate fieldsModel
            in
            if List.isEmpty errors then
                let
                    newModel =
                        { fieldsModel
                            | errors = errors
                            , password = ""
                            , passwordConfirm = ""
                            , showFields = False
                        }

                    cmd =
                        { email = fieldsModel.email
                        , username = fieldsModel.username
                        , password = fieldsModel.password
                        }
                            |> Register
                            |> Ports.send
                in
                newModel & cmd
            else
                { fieldsModel
                    | errors = errors
                    , password = ""
                    , passwordConfirm = ""
                }
                    & Cmd.none


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
