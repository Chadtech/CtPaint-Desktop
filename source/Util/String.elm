module Util.String exposing (isBlank)


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
