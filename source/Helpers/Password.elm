module Helpers.Password exposing (validate)

import Util


validate : String -> String -> Maybe String
validate password passwordConfirm =
    [ passwordsMatch password passwordConfirm
    , atLeastOneLowerCase password
    , atLeastOneUpperCase password
    , atLeastOneSpecialCharacter password
    , longEnough password
    ]
        |> Util.firstJust


passwordsMatch : String -> String -> Maybe String
passwordsMatch password passwordConfirm =
    if password == passwordConfirm then
        Nothing
    else
        Just "passwords do not match"


atLeastOneUpperCase : String -> Maybe String
atLeastOneUpperCase password =
    if password == String.toLower password then
        Just "password must contain at least one upper case letter"
    else
        Nothing


atLeastOneLowerCase : String -> Maybe String
atLeastOneLowerCase password =
    if password == String.toUpper password then
        Just "password must contain at least one lower case letter"
    else
        Nothing


longEnough : String -> Maybe String
longEnough password =
    if String.length password < 8 then
        Just "password must be at least 8 characters"
    else
        Nothing


atLeastOneSpecialCharacter : String -> Maybe String
atLeastOneSpecialCharacter password =
    if containsSpecialCharacter password then
        Nothing
    else
        Just "password must contain at least one special character"


containsSpecialCharacter : String -> Bool
containsSpecialCharacter password =
    password
        |> String.toList
        |> List.filter (Util.contains specialCharacters)
        |> List.isEmpty
        |> not


specialCharacters : List Char
specialCharacters =
    "^$*.[]{}()?-\"!@#%&/\\,><':;|_~`"
        |> String.toList
