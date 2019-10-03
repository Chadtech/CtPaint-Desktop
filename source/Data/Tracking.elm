module Data.Tracking exposing
    ( Event
    , event
    , send
    , tag
    , withBool
    , withListenerResponse
    , withProp
    , withResult
    , withString
    )

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

import Data.Listener as Listener
import Json.Encode as Encode exposing (Value)
import Ports



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


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


tag : String -> Maybe Event -> Maybe Event
tag propName =
    withProp propName Encode.null


withListenerResponse : Listener.Response String value -> Maybe Event -> Maybe Event
withListenerResponse =
    withResult (Listener.errorToString identity)


withResult : (error -> String) -> Result error value -> Maybe Event -> Maybe Event
withResult encodeError result =
    case result of
        Ok _ ->
            withString "response" "Ok"

        Err error ->
            withString "response" "Error"
                >> withString "error" (encodeError error)


withString : String -> String -> Maybe Event -> Maybe Event
withString propName =
    encodeString >> Encode.string >> withProp propName


withBool : String -> Bool -> Maybe Event -> Maybe Event
withBool propName =
    Encode.bool >> withProp propName


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


encodeProps : List ( String, Encode.Value ) -> Ports.Payload -> Ports.Payload
encodeProps remainingProps =
    case remainingProps of
        [] ->
            identity

        ( propName, propValue ) :: rest ->
            Ports.withProp
                (encodeString propName)
                propValue
                >> encodeProps rest


send : Maybe Event -> Cmd msg
send maybeEvent =
    case maybeEvent of
        Just { name, props } ->
            Ports.payload "track"
                |> Ports.withString
                    "name"
                    name
                |> encodeProps props
                |> Ports.send

        Nothing ->
            Cmd.none


encodeString : String -> String
encodeString =
    String.replace " " "_"
