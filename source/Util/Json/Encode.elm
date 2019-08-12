module Util.Json.Encode exposing (maybe)

import Json.Encode as Encode


maybe : (a -> Encode.Value) -> Maybe a -> Encode.Value
maybe encoder =
    Maybe.map encoder >> Maybe.withDefault Encode.null
