module Helpers.Email exposing (validate)


validate : String -> Bool
validate email =
    case String.split "@" email of
        "" :: _ ->
            False

        local :: domain :: [] ->
            separateDomain domain local

        _ ->
            False


separateDomain : String -> String -> Bool
separateDomain domain local =
    case String.split "." domain of
        _ :: "" :: [] ->
            False

        "" :: _ :: [] ->
            False

        name :: extension :: [] ->
            [ local, name, extension ]
                |> String.concat
                |> String.all isAlphanumeric

        _ ->
            False


isAlphanumeric : Char -> Bool
isAlphanumeric char =
    String.contains (String.fromChar char) alphanumeric


alphanumeric : String
alphanumeric =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
