module Util.Tuple3 exposing
    ( mapFirst
    , mapSecond
    )


mapFirst : (a -> b) -> ( a, c, d ) -> ( b, c, d )
mapFirst f ( a, b, c ) =
    ( f a, b, c )


mapSecond : (b -> c) -> ( a, b, d ) -> ( a, c, d )
mapSecond f ( a, b, c ) =
    ( a, f b, c )
