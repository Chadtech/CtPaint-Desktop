module Data.Tracking
    exposing
        ( Event
        , Payload
        , encode
        , namespace
        , noProps
        , response
        )

import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Util exposing (def)


-- TYPES --


type alias Payload =
    { name : String
    , properties : List ( String, Value )
    , sessionId : Id
    , email : Maybe String
    , buildNumber : Int
    }


type alias Event =
    ( String, List ( String, Value ) )



-- HELPERS --


noProps : String -> Maybe Event
noProps name =
    Just (def name [])


response : Maybe String -> Maybe Event
response maybeError =
    maybeError
        |> Encode.maybe Encode.string
        |> def "error"
        |> List.singleton
        |> def "response"
        |> Just


namespace : String -> Maybe Event -> Maybe Event
namespace name =
    Maybe.map (Tuple.mapFirst ((++) (name ++ " ")))



-- PUBLIC --


encode : Payload -> Value
encode payload =
    [ payload.name
        |> String.split " "
        |> String.join "_"
        |> Encode.string
        |> def "name"
    , def "properties" <| encodeProperties payload
    ]
        |> Encode.object


encodeProperties : Payload -> Value
encodeProperties payload =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| Encode.maybe Encode.string payload.email
    , def "buildNumber" <| Encode.int payload.buildNumber
    ]
        |> List.append payload.properties
        |> Encode.object
