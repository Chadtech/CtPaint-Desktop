module Data.Field exposing
    ( Field
    , batchValidations
    , clearError
    , getError
    , getValue
    , hasError
    , init
    , initWithValue
    , setError
    , setValue
    , validate
    , validateEmail
    , validateIsNotBlank
    , validatePassword
    )

import Util.String as StringUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Field =
    { value : String
    , error : Maybe String
    }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Field
init =
    initWithValue ""


initWithValue : String -> Field
initWithValue str =
    { value = str, error = Nothing }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setError : String -> Field -> Field
setError error field =
    { field | error = Just error }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getValue : Field -> String
getValue =
    .value


getError : Field -> Maybe String
getError =
    .error


hasError : Field -> Bool
hasError =
    getError >> (/=) Nothing


clearError : Field -> Field
clearError field =
    { field | error = Nothing }


setValue : String -> Field -> Field
setValue newValue field =
    { field | value = newValue }


validate :
    { valid : String -> Bool
    , errorMessage : String
    }
    -> Field
    -> Field
validate { valid, errorMessage } field =
    if valid field.value then
        clearError field

    else
        setError errorMessage field


validateEmail : Field -> Field
validateEmail =
    [ validateIsNotBlank
        { errorMessage = "you must enter your email" }
    , validate
        { valid = StringUtil.isValidEmail
        , errorMessage = "this is not a valid email address"
        }
    ]
        |> batchValidations


validateIsNotBlank : { errorMessage : String } -> Field -> Field
validateIsNotBlank { errorMessage } =
    validate
        { valid = not << StringUtil.isBlank
        , errorMessage = errorMessage
        }


validatePassword : Field -> Field
validatePassword =
    [ validateIsNotBlank
        { errorMessage = "you must enter your password" }
    , validate
        { valid = StringUtil.containsUppercase
        , errorMessage = "password must contain at least one upper case character"
        }
    , validate
        { valid = StringUtil.containsLowercase
        , errorMessage = "password must contain at least one lower case character"
        }
    , validate
        { valid = StringUtil.lengthIsAtLeast 8
        , errorMessage = "password must be at least 8 characters"
        }
    , validate
        { valid = StringUtil.containsSpecialCharacter
        , errorMessage = "password must contain at least one special character"
        }
    ]
        |> batchValidations


batchValidations : List (Field -> Field) -> Field -> Field
batchValidations checks field =
    case checks of
        first :: rest ->
            let
                checkedField : Field
                checkedField =
                    first field
            in
            if checkedField.error == Nothing then
                batchValidations rest field

            else
                checkedField

        [] ->
            field
