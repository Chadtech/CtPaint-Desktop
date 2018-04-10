module Tracking
    exposing
        ( Event(..)
        , Payload
        , encode
        )

import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Keyboard.Extra.Browser exposing (Browser)
import Util exposing (def)


-- TYPES --


type alias Payload =
    { event : Event
    , sessionId : Id
    , email : Maybe String
    }


type alias InitValues =
    { isMac : Bool
    , browser : Browser
    , buildNumber : Int
    }


type Event
    = AppInit InitValues
    | AppInitFail String
    | PageRoadMapWantClick String
    | PageContactSubmitClick String



-- PUBLIC --


encode : Payload -> Value
encode payload =
    let
        ( name, eventProperties ) =
            encodeEvent payload.event
    in
    [ name
        |> String.split " "
        |> String.join "_"
        |> Encode.string
        |> def "name"
    , def "properties" <| encodeProperties payload eventProperties
    ]
        |> Encode.object


encodeProperties : Payload -> List ( String, Value ) -> Value
encodeProperties payload eventProperties =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| Encode.maybe Encode.string payload.email
    ]
        ++ eventProperties
        |> Encode.object


encodeEvent : Event -> ( String, List ( String, Value ) )
encodeEvent event =
    case event of
        AppInit initValues ->
            []
                |> def "app init"

        AppInitFail problem ->
            [ def "problem" <| Encode.string problem ]
                |> def "app fail init"

        PageRoadMapWantClick want ->
            [ def "want" <| Encode.string want ]
                |> def "page roadmap want click"

        PageContactSubmitClick comment ->
            [ def "comment" <| Encode.string comment ]
                |> def "page contact submit click"
