module Session exposing
    ( Msg
    , Session
    , decoder
    , formatTime
    , getBuildNumber
    , getContactEmail
    , getMountPath
    , getNavKey
    , getSessionId
    , init
    , subscriptions
    , track
    , update
    )

import Browser.Events
import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.MountPath as MountPath exposing (MountPath)
import Data.NavKey exposing (NavKey)
import Data.SessionId as SessionId exposing (SessionId)
import Data.Size as Size exposing (Size)
import Data.Tracking as Tracking
import Json.Decode as Decode exposing (Decoder)
import Random exposing (Seed)
import Task
import Time exposing (Posix)
import Util.Int as IntUtil
import Util.Json.Decode as DecodeUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Session =
    { mountPath : MountPath
    , navKey : NavKey
    , buildNumber : BuildNumber
    , sessionId : SessionId
    , seed : Seed
    , windowSize : Size
    , contactEmail : String
    , timezone : Timezone
    }


type Timezone
    = Fallback Time.Zone
    | Loaded Time.Zone


type Msg
    = WindowResized Size
    | GotTimezone Time.Zone



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Cmd Msg
init =
    Task.perform GotTimezone Time.here



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setWindowSize : Size -> Session -> Session
setWindowSize newSize session =
    { session | windowSize = newSize }


loadedTimezone : Time.Zone -> Session -> Session
loadedTimezone zone session =
    { session | timezone = Loaded zone }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


decoder : NavKey -> Decoder Session
decoder navKey =
    let
        windowSizeDecoder : Decoder Size
        windowSizeDecoder =
            Decode.succeed Size
                |> DecodeUtil.applyField "windowHeight" Decode.int
                |> DecodeUtil.applyField "windowWidth" Decode.int

        fromSeed : Seed -> Decoder Session
        fromSeed seed0 =
            let
                ( sessionId, seed1 ) =
                    Random.step
                        SessionId.generator
                        seed0
            in
            Decode.succeed Session
                |> DecodeUtil.applyField "mountPath" MountPath.decoder
                |> DecodeUtil.set navKey
                |> DecodeUtil.applyField "buildNumber" BuildNumber.decoder
                |> DecodeUtil.set sessionId
                |> DecodeUtil.set seed1
                |> DecodeUtil.apply windowSizeDecoder
                |> DecodeUtil.set "ctpaint@programhouse.us"
                |> DecodeUtil.set (Fallback Time.utc)
    in
    Decode.map Random.initialSeed Decode.int
        |> Decode.field "seed"
        |> Decode.andThen fromSeed


getContactEmail : Session -> String
getContactEmail =
    .contactEmail


getBuildNumber : Session -> BuildNumber
getBuildNumber =
    .buildNumber


getMountPath : Session -> MountPath
getMountPath =
    .mountPath


getNavKey : Session -> NavKey
getNavKey =
    .navKey


getSessionId : Session -> SessionId
getSessionId =
    .sessionId


formatTime : Session -> Posix -> String
formatTime session =
    formatTimeHelp session.timezone


formatTimeHelp : Timezone -> Posix -> String
formatTimeHelp timezone time =
    case timezone of
        Fallback zone ->
            formatTimeHelp (Loaded zone) time ++ " utc"

        Loaded zone ->
            let
                year : Int
                year =
                    Time.toYear zone time

                month : Int
                month =
                    case Time.toMonth zone time of
                        Time.Jan ->
                            1

                        Time.Feb ->
                            2

                        Time.Mar ->
                            3

                        Time.Apr ->
                            4

                        Time.May ->
                            5

                        Time.Jun ->
                            6

                        Time.Jul ->
                            7

                        Time.Aug ->
                            8

                        Time.Sep ->
                            9

                        Time.Oct ->
                            10

                        Time.Nov ->
                            11

                        Time.Dec ->
                            12

                day : Int
                day =
                    Time.toDay zone time

                hour : String
                hour =
                    Time.toHour zone time
                        |> IntUtil.toDoubleDigitString

                minute : String
                minute =
                    Time.toMinute zone time
                        |> IntUtil.toDoubleDigitString
            in
            [ [ year, month, day ]
                |> List.map IntUtil.toDoubleDigitString
                |> String.join "-"
            , hour ++ ":" ++ minute
            ]
                |> String.join " "



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Session -> Session
update msg =
    case msg of
        WindowResized size ->
            setWindowSize size

        GotTimezone zone ->
            loadedTimezone zone


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        WindowResized size ->
            Tracking.event "window resized"
                |> Tracking.withString "size" (Size.toString size)

        GotTimezone _ ->
            Nothing



-------------------------------------------------------------------------------
-- SUBSCRIPTIONS --
-------------------------------------------------------------------------------


subscriptions : Sub Msg
subscriptions =
    Browser.Events.onResize Size
        |> Sub.map WindowResized
