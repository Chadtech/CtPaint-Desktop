module Util.Int exposing (toDoubleDigitString)


toDoubleDigitString : Int -> String
toDoubleDigitString i =
    if 0 <= i && i < 10 then
        "0" ++ String.fromInt i

    else
        String.fromInt i
