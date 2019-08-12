module Util.List exposing (contains)


contains : List a -> a -> Bool
contains list item =
    List.member item list
