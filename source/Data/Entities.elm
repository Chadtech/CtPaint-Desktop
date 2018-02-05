module Data.Entities
    exposing
        ( Entities
        , empty
        )

import Data.Drawing exposing (Drawing)
import Dict exposing (Dict)


{-|

    Formal term : Entities
    This app gets data from the back end,
    each of which certainly has an id, and
    has to be kept in sync with the back end.
    Entities is like a client side database
    that keeps track of the most recent versions
    of that back end data.

-}
type alias Entities =
    { drawings : Dict String Drawing }


empty : Entities
empty =
    { drawings = Dict.empty }
