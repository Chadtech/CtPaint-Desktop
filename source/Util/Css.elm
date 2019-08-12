module Util.Css exposing
    ( noStyle
    , styleIf
    , styleMaybe
    )

import Css exposing (Style)


styleIf : Bool -> Style -> Style
styleIf condition style =
    if condition then
        style

    else
        noStyle


styleMaybe : (a -> Style) -> Maybe a -> Style
styleMaybe f =
    Maybe.map f >> Maybe.withDefault noStyle


noStyle : Style
noStyle =
    Css.batch []
