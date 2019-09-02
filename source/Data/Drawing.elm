module Data.Drawing exposing
    ( Drawing
    , PublicId
    , decoder
    , getCreatedAt
    , getDrawingUrl
    , getName
    , getPublicId
    , getUpdatedAt
    , publicIdToString
    , publicIdUrlParser
    )

import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Time exposing (Posix)
import Url.Parser as Url
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
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


publicIdUrlParser : Url.Parser (PublicId -> a) a
publicIdUrlParser =
    Url.map PublicId Url.string


publicIdToString : PublicId -> String
publicIdToString (PublicId publicId) =
    publicId


getDrawingUrl : PublicId -> String
getDrawingUrl (PublicId publicId) =
    [ "https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads"
    , publicId
    ]
        |> String.join "/"


getPublicId : Drawing -> PublicId
getPublicId =
    .publicId


getName : Drawing -> String
getName =
    .name


getCreatedAt : Drawing -> Posix
getCreatedAt =
    .createdAt


getUpdatedAt : Drawing -> Posix
getUpdatedAt =
    .updatedAt


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
