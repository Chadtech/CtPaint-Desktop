module Data.Drawing
    exposing
        ( Drawing
        , decoder
        )

import Date exposing (Date)
import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


type alias Drawing =
    { id : Id
    , publicId : String
    , data : String
    , name : String
    , createdAt : Date
    , updatedAt : Date
    }


decoder : Decoder Drawing
decoder =
    decode Drawing
        |> required "drawingId" Id.decoder
        |> required "publicId" Decode.string
        |> required "canvas" Decode.string
        |> required "name" Decode.string
        |> required "createdAt" dateDecoder
        |> required "updatedAt" dateDecoder


dateDecoder : Decoder Date
dateDecoder =
    Decode.map Date.fromTime Decode.float
