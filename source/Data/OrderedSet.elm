module Data.OrderedSet exposing
    ( OrderedSet
    , cons
    , empty
    , member
    , remove
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type OrderedSet a
    = OrderedSet (List a)



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


empty : OrderedSet a
empty =
    OrderedSet []


cons : a -> OrderedSet a -> OrderedSet a
cons item orderedSet =
    case remove item orderedSet of
        OrderedSet filteredSet ->
            OrderedSet (item :: filteredSet)


member : a -> OrderedSet a -> Bool
member item (OrderedSet list) =
    List.member item list


remove : a -> OrderedSet a -> OrderedSet a
remove item (OrderedSet list) =
    List.filter ((==) item) list
        |> OrderedSet
