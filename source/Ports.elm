port module Ports exposing
    ( Payload
    , fromJs
    , payload
    , send
    , withProp
    , withString
    )

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


withString : String -> String -> Payload -> Payload
withString propName stringValue =
    withProp propName (Encode.string stringValue)


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


withProp : String -> Encode.Value -> Payload -> Payload
withProp propName value { name, props } =
    { name = name
    , props = ( propName, value ) :: props
    }



-------------------------------------------------------------------------------
-- PRIVATE  HELPERS --
-------------------------------------------------------------------------------


port toJs : Encode.Value -> Cmd msg


port fromJs : (Decode.Value -> msg) -> Sub msg
