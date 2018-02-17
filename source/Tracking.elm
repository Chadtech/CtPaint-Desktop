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
import Tuple.Infix exposing ((:=))


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


type Event
    = AppInitialized
    | AppFailedToInitialize String
    | WantClicked String


encode : Payload -> Value
encode { event, sessionId, email } =
    [ "event" := encodeEvent event
    , "sessionId" := Id.encode sessionId
    , "email" := Encode.maybe Encode.string email
    ]
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    case event of
        AppInitialized ->
            [ "name" := Encode.string "app initialized" ]
                |> Encode.object

        AppFailedToInitialize problem ->
            [ "name" := Encode.string "app failed to initialized"
            , "problem" := Encode.string problem
            ]
                |> Encode.object

        WantClicked want ->
            [ "name" := Encode.string "want clicked"
            , "want" := Encode.string want
            ]
                |> Encode.object
