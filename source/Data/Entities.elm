module Data.Entities
    exposing
        ( Entities
        , empty
        , loadDrawings
        )

import Data.Drawing exposing (Drawing)
import Id


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
    { drawings : Id.Dict Drawing }


loadDrawings : Entities -> List Drawing -> Entities
loadDrawings entities drawings =
    { entities
        | drawings =
            drawings
                |> Id.toDict .id
                |> Id.merge entities.drawings
    }


empty : Entities
empty =
    { drawings = Id.emptyDict .id }
