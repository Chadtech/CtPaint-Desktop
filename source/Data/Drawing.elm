module Data.Drawing
    exposing
        ( Drawing
        , decoder
        , toUrl
        )

import Date exposing (Date)
import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


type alias Drawing =
    { id : Id
    , publicId : Id
    , data : String
    , name : String
    , createdAt : Date
    , updatedAt : Date
    }


decoder : Decoder Drawing
decoder =
    decode Drawing
        |> required "drawingId" Id.decoder
        |> required "publicId" Id.decoder
        |> required "canvas" Decode.string
        |> required "name" Decode.string
        |> required "createdAt" dateDecoder
        |> required "updatedAt" dateDecoder


dateDecoder : Decoder Date
dateDecoder =
    Decode.map Date.fromTime Decode.float



-- HELPERS --


toUrl : Id -> String
toUrl publicId =
    [ "https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads"
    , Id.toString publicId
    ]
        |> String.join "/"
