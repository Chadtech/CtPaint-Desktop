module Data.Drawing
    exposing
        ( Drawing
        , decoder
        )

import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


type alias Drawing =
    { id : Id
    , data : String
    , name : String
    }


decoder : Decoder Drawing
decoder =
    decode Drawing
        |> required "drawingId" Id.decoder
        |> required "canvas" Decode.string
        |> required "name" Decode.string
