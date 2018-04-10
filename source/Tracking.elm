module Tracking
    exposing
        ( Event(..)
        , Payload
        , encode
        , fromTaco
        )

import Data.Taco exposing (Taco)
import Data.User as User
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


fromTaco : Taco -> Event -> Payload
fromTaco taco event =
    { event = event
    , sessionId = taco.config.sessionId
    , email =
        case taco.user of
            User.LoggedIn { email } ->
                Just email

            _ ->
                Nothing
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


encode : Payload -> Value
encode { event, sessionId, email } =
    [ def "event" <| encodeEvent event
    , def "sessionId" <| Id.encode sessionId
    , def "email" <| Encode.maybe Encode.string email
    ]
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    case event of
        AppInit initValues ->
            [ def "name" <| Encode.string "app initialized" ]
                |> Encode.object

        AppInitFail problem ->
            [ def "name" <| Encode.string "app failed to initialized"
            , def "problem" <| Encode.string problem
            ]
                |> Encode.object

        PageRoadMapWantClick want ->
            [ def "name" <| Encode.string "want clicked"
            , def "want" <| Encode.string want
            ]
                |> Encode.object

        PageContactSubmitClick comment ->
            [ def "comment" <| Encode.string comment ]
                |> Encode.object
