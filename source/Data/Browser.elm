module Data.Browser exposing
    ( Browser
    , decoder
    , encode
    )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Browser
    = Opera
    | InternetExplorer
    | FireFox
    | Safari
    | Chrome



-------------------------------------------------------------------------------
-- VALUES --
-------------------------------------------------------------------------------


firefox : Browser
firefox =
    FireFox


chrome : Browser
chrome =
    Chrome



-------------------------------------------------------------------------------
-- VALUES --
-------------------------------------------------------------------------------


toString : Browser -> String
toString browser =
    case browser of
        Opera ->
            "Opera"

        InternetExplorer ->
            "InternetExplorer"

        FireFox ->
            "FireFox"

        Safari ->
            "Safari"

        Chrome ->
            "Chrome"


encode : Browser -> Encode.Value
encode =
    Encode.string << toString


decoder : Decoder Browser
decoder =
    let
        fromString : String -> Decoder Browser
        fromString str =
            case str of
                "Firefox" ->
                    Decode.succeed FireFox

                "Chrome" ->
                    Decode.succeed Chrome

                "Unknown" ->
                    Decode.succeed Chrome

                other ->
                    Decode.fail ("Unknown browser type " ++ other)
    in
    Decode.string
        |> Decode.andThen fromString
