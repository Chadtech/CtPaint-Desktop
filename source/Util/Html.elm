module Util.Html exposing
    ( mapList
    , onEnter
    )

import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)


mapList : (a -> b) -> List (Html a) -> List (Html b)
mapList f =
    List.map (Html.map f)


onEnter : msg -> Attribute msg
onEnter msg =
    let
        fromCode : Int -> Decoder msg
        fromCode code =
            if code == 13 then
                Decode.succeed msg

            else
                Decode.fail "Key is not enter"
    in
    Events.keyCode
        |> Decode.andThen fromCode
        |> Events.on "keydown"
