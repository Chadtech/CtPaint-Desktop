module Data.Document exposing
    ( Document
    , cons
    , map
    , toBrowserDocument
    )

import Browser
import Html.Styled as Html exposing (Html)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


{-| Really just Browser.Document except using Html.Styled.
But also, by having this type in my application, and not
as a dependency, I can made broad changes to the application.
-}
type alias Document msg =
    { title : Maybe String
    , body : List (Html msg)
    }



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


toBrowserDocument : Document msg -> Browser.Document msg
toBrowserDocument { title, body } =
    { title =
        case title of
            Nothing ->
                titleRoot

            Just title_ ->
                [ titleRoot
                , "|"
                , title_
                ]
                    |> String.join " "
    , body =
        List.map Html.toUnstyled body
    }


cons : Html msg -> Document msg -> Document msg
cons element document =
    { document | body = element :: document.body }


titleRoot : String
titleRoot =
    "CtPaint"


map : (a -> b) -> Document a -> Document b
map mapper document =
    { title = document.title
    , body =
        List.map (Html.map mapper) document.body
    }
