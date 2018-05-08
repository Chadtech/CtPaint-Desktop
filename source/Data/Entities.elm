module Data.Entities
    exposing
        ( Entities
        , deleteDrawing
        , empty
        , loadDrawings
        )

import Data.Drawing exposing (Drawing)
import Id exposing (Db, Id)


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
    { drawings : Db Drawing }


empty : Entities
empty =
    { drawings = Id.emptyDb .id }



-- HELPERS --


loadDrawings : Entities -> List Drawing -> Entities
loadDrawings entities drawings =
    { entities
        | drawings =
            List.foldr
                Id.insert
                entities.drawings
                drawings
    }


deleteDrawing : Id -> Entities -> Entities
deleteDrawing id entities =
    { entities
        | drawings =
            Id.remove id entities.drawings
    }
