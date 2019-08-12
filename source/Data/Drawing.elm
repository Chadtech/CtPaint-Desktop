module Data.Drawing exposing
    ( Drawing
    , decoder
    , toUrl
    )

import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Time exposing (Posix)
import Util.Json.Decode as DecodeUtil
import Util.Posix as PosixUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Drawing =
    { publicId : PublicId
    , data : String
    , name : String
    , createdAt : Posix
    , updatedAt : Posix
    }


type PublicId
    = PublicId String



-------------------------------------------------------------------------------
-- DECODER --
-------------------------------------------------------------------------------


decoder : Decoder ( Id Drawing, Drawing )
decoder =
    let
        contentDecoder : Decoder Drawing
        contentDecoder =
            Decode.succeed Drawing
                |> DecodeUtil.applyField "publicId" (Decode.map PublicId Decode.string)
                |> DecodeUtil.applyField "canvas" Decode.string
                |> DecodeUtil.applyField "name" Decode.string
                |> DecodeUtil.applyField "createdAt" PosixUtil.decoder
                |> DecodeUtil.applyField "updatedAt" PosixUtil.decoder
    in
    Decode.map2 Tuple.pair
        (Decode.field "drawingId" Id.decoder)
        contentDecoder



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


toUrl : PublicId -> String
toUrl (PublicId publicId) =
    [ "https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads"
    , publicId
    ]
        |> String.join "/"
