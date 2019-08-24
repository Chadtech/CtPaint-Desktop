port module Ports exposing
    ( Payload
    , fromJs
    , payload
    , send
    , withId
    , withNoProps
    , withProp
    , withString
    )

import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Payload =
    { name : String
    , props : List ( String, Encode.Value )
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


payload : String -> Payload
payload name =
    { name = String.replace " " "_" name
    , props = []
    }


withNoProps : String -> Cmd msg
withNoProps =
    payload >> send


withId : String -> Id a -> Payload -> Payload
withId propName id =
    withProp propName (Id.encode id)


withString : String -> String -> Payload -> Payload
withString propName stringValue =
    withProp propName (Encode.string stringValue)


withProp : String -> Encode.Value -> Payload -> Payload
withProp propName value { name, props } =
    { name = name
    , props = ( propName, value ) :: props
    }


send : Payload -> Cmd msg
send { name, props } =
    let
        encodedProps : Encode.Value
        encodedProps =
            if List.isEmpty props then
                Encode.null

            else
                Encode.object props
    in
    [ Tuple.pair "name" (Encode.string name)
    , Tuple.pair "props" encodedProps
    ]
        |> Encode.object
        |> toJs



-------------------------------------------------------------------------------
-- PRIVATE  HELPERS --
-------------------------------------------------------------------------------


port toJs : Encode.Value -> Cmd msg


port fromJs : (Decode.Value -> msg) -> Sub msg
