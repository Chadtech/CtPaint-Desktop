module Util.Posix exposing (decoder)

import Json.Decode as Decode exposing (Decoder)
import Time exposing (Posix)


decoder : Decoder Posix
decoder =
    Decode.map Time.millisToPosix Decode.int
