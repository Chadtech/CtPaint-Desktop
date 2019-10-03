module Util.Random exposing
    ( alphanumeric
    , shuffle
    )

import Random exposing (Generator, Seed)
import Util.String as StringUtil


{-| Take a list, and randomly re-arrange the
list so that its members are in randomly
different order
-}
shuffle : List a -> Seed -> ( List a, Seed )
shuffle =
    shuffleHelper []


shuffleHelper : List a -> List a -> Seed -> ( List a, Seed )
shuffleHelper done remaining seed =
    let
        get : a -> List a -> Int -> ( a, List a )
        get first rest index =
            case rest of
                [] ->
                    ( first, [] )

                second :: rest_ ->
                    if index == 0 then
                        ( first, rest )

                    else
                        get second rest_ (index - 1)
                            |> Tuple.mapSecond ((::) first)

        indexGenerator : List a -> Generator Int
        indexGenerator list =
            Random.int 0 (List.length list - 1)
    in
    case remaining of
        [] ->
            ( done, seed )

        first :: rest ->
            let
                ( ( randomElement, newRemaining ), newSeed ) =
                    Random.step (indexGenerator remaining) seed
                        |> Tuple.mapFirst (get first rest)
            in
            shuffleHelper
                (randomElement :: done)
                newRemaining
                newSeed


alphanumeric : Int -> Generator String
alphanumeric length_ =
    Random.uniform
        (Tuple.first StringUtil.alphanumeric)
        (Tuple.second StringUtil.alphanumeric)
        |> Random.list length_
        |> Random.map String.fromList
