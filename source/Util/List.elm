module Util.List exposing (push)


push : a -> List a -> List a
push item list =
    list ++ [ item ]
