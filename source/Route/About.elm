module Route.About exposing
    ( Route(..)
    , all
    , parser
    , toLabel
    , toUrlPieces
    )

import Url.Parser as Url exposing (Parser, s)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Route
    = Info
    | Contact
    | RoadMap



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


toLabel : Route -> String
toLabel route =
    case route of
        Info ->
            "info"

        Contact ->
            "contact"

        RoadMap ->
            "road map"


all : List Route
all =
    let
        typeCheckingReminder : Route -> ()
        typeCheckingReminder route =
            ---------------------------
            -- This is your reminder --
            -- to add you new Route  --
            -- to the list below     --
            ---------------------------
            case route of
                Info ->
                    ()

                Contact ->
                    ()

                RoadMap ->
                    ()
    in
    [ Info
    , Contact
    , RoadMap
    ]


parser : Parser (Route -> a) a
parser =
    [ Url.map Info Url.top
    , Url.map Info (s "info")
    , Url.map Contact (s "contact")
    , Url.map RoadMap (s "roadmap")
    ]
        |> Url.oneOf


toUrlPieces : Route -> List String
toUrlPieces route =
    case route of
        Info ->
            [ "info" ]

        Contact ->
            [ "contact" ]

        RoadMap ->
            [ "roadmap" ]
