module Util.String exposing
    ( containsLowercase
    , containsSpecialCharacter
    , containsUppercase
    , isBlank
    , isValidEmail
    , lengthIsAtLeast
    )

import Regex exposing (Regex)


containsUppercase : String -> Bool
containsUppercase str =
    str /= String.toLower str


containsLowercase : String -> Bool
containsLowercase str =
    str /= String.toUpper str


containsSpecialCharacter : String -> Bool
containsSpecialCharacter str =
    let
        specialCharacters : List Char
        specialCharacters =
            "^$*.[]{}()?-\"!@#%&/\\,><':;|_~`"
                |> String.toList

        isSpecialCharacter : Char -> Bool
        isSpecialCharacter char =
            List.member char specialCharacters
    in
    str
        |> String.toList
        |> List.map isSpecialCharacter
        |> List.foldr (||) False


lengthIsAtLeast : Int -> String -> Bool
lengthIsAtLeast length str =
    String.length str >= length


isBlank : String -> Bool
isBlank str =
    let
        isWhitespaceChar : Char -> Bool
        isWhitespaceChar char =
            char == ' ' || char == '\n' || char == '\t' || char == '\u{000D}'
    in
    case String.uncons str of
        Just ( char, rest ) ->
            if isWhitespaceChar char then
                isBlank rest

            else
                False

        Nothing ->
            True


isValidEmail : String -> Bool
isValidEmail email =
    Regex.contains validEmail email


validEmail : Regex
validEmail =
    "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        |> Regex.fromStringWith
            { caseInsensitive = True
            , multiline = False
            }
        |> Maybe.withDefault Regex.never
