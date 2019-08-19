module Util.Function exposing (composeMany)


composeMany : List (a -> a) -> a -> a
composeMany =
    List.foldr (>>) identity
