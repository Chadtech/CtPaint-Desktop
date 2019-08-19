module Util.Tuple exposing (append)


append : c -> ( a, b ) -> ( a, b, c )
append c ( a, b ) =
    ( a, b, c )
