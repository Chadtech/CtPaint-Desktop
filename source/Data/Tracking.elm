module Data.Tracking exposing
    ( Event
    , Payload
    , encode
    , event
    , namespace
    , withProp
    )

import Data.SessionId as SesionId exposing (SessionId)
import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Util.Json.Encode as EncodeUtil


{-|

    Tracking refers to tracking UX events, like
    clicks, and navigations, and http responses.
    Those events are listened to, and then sent
    to the backend to be stored. This tracking
    data is really useful for development.
    Errors, for example, are tracked. There
    are always really ugly errors the user
    experiences that the developer is totally
    unaware of. More generally tho, knowing how
    users use the application helps developers
    know what to develop. It helps developers
    know what users want.

-}



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Payload =
    { name : String
    , props : List ( String, Value )
    , sessionId : SessionId
    , email : Maybe String
    }


type alias Event =
    { name : String
    , props : List ( String, Value )
    }



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


event : String -> Maybe Event
event name =
    Just { name = name, props = [] }


withProp : String -> Encode.Value -> Maybe Event -> Maybe Event
withProp propName value maybeEvent =
    case maybeEvent of
        Just event_ ->
            Just
                { event_
                    | props =
                        ( propName, value ) :: event_.props
                }

        Nothing ->
            Nothing


namespace : String -> Maybe Event -> Maybe Event
namespace name maybeEvent =
    case maybeEvent of
        Just event_ ->
            Just
                { event_
                    | name =
                        [ name, event_.name ]
                            |> String.join " "
                }

        Nothing ->
            Nothing


encode : Payload -> Value
encode { name, props, email, sessionId } =
    let
        encodedProps : Value
        encodedProps =
            [ Tuple.pair "sessionId" <|
                SesionId.encode sessionId
            , Tuple.pair "email" <|
                EncodeUtil.maybe Encode.string email
            ]
                |> List.append props
                |> Encode.object
    in
    [ name
        |> String.replace " " "_"
        |> Encode.string
        |> Tuple.pair "name"
    , Tuple.pair "properties" encodedProps
    ]
        |> Encode.object
