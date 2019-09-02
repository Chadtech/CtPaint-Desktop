module Route.PaintApp exposing
    ( Params
    , Route(..)
    , parser
    , toUrlPieces
    )

import Data.BackgroundColor as BackgroundColor exposing (BackgroundColor)
import Data.Drawing as Drawing exposing (Drawing)
import Data.Size as Size exposing (Size)
import Url
import Url.Parser as Url exposing ((</>), (<?>), Parser)
import Url.Parser.Query as Query



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Route
    = Landing
    | WithParams Params
    | FromUrl String
    | FromDrawing Drawing.PublicId


type alias Params =
    { dimensions : Maybe Size
    , backgroundColor : Maybe BackgroundColor
    , name : Maybe String
    }



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


parser : Parser (Route -> a) a
parser =
    [ Url.map Landing Url.top
    , (Url.top
        <?> Query.int "width"
        <?> Query.int "height"
        <?> Query.custom
                "background_color"
                BackgroundColor.queryParser
        <?> Query.string "name"
      )
        |> Url.map toParams
        |> Url.map WithParams
    , Url.map FromUrl (Url.s "url" </> Url.string)
    , Url.map
        FromDrawing
        (Url.s "id" </> Drawing.publicIdUrlParser)
    ]
        |> Url.oneOf


toParams : Maybe Int -> Maybe Int -> Maybe BackgroundColor -> Maybe String -> Params
toParams maybeWidth maybeHeight maybeBackgroundColor maybeName =
    { dimensions =
        Maybe.map2
            Size
            maybeWidth
            maybeHeight
    , backgroundColor = maybeBackgroundColor
    , name = maybeName
    }


toUrlPieces : Route -> List String
toUrlPieces route =
    case route of
        Landing ->
            []

        WithParams { backgroundColor, name, dimensions } ->
            let
                encodePair : ( String, String ) -> String
                encodePair ( key, value ) =
                    key ++ "=" ++ value
            in
            [ [ Maybe.map
                    (Tuple.pair "background_color" << BackgroundColor.toString)
                    backgroundColor
              , Maybe.map (Tuple.pair "name") name
              , Maybe.map (Tuple.pair "size" << Size.toString) dimensions
              ]
                |> List.filterMap identity
                |> List.map encodePair
                |> String.join "&"
                |> (++) "?"
            ]

        FromUrl url ->
            [ "url", Url.percentEncode url ]

        FromDrawing id ->
            [ "id", Drawing.publicIdToString id ]
