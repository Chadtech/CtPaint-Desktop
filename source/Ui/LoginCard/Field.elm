module Ui.LoginCard.Field exposing
    ( Field
    , getValue
    , init
    , setError
    , setValue
    , validate
    )

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
    { value = ""
    , error = Nothing
    }



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
        field

    else
        setError errorMessage field
