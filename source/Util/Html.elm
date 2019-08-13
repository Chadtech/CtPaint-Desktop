module Util.Html exposing (mapList)

import Html.Styled as Html exposing (Html)


mapList : (a -> b) -> List (Html a) -> List (Html b)
mapList f =
    List.map (Html.map f)
