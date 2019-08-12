module Data.SessionId exposing
    ( SessionId
    , encode
    , error
    , generator
    )

import Id exposing (Id)
import Json.Encode as Encode
import Random exposing (Generator)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type SessionId
    = SessionId (Id ())



-------------------------------------------------------------------------------
-- VALUE --
-------------------------------------------------------------------------------


error : SessionId
error =
    SessionId <| Id.fromString "ERROR"



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


generator : Generator SessionId
generator =
    Random.map SessionId Id.generator


encode : SessionId -> Encode.Value
encode (SessionId sessionId) =
    Id.encode sessionId
