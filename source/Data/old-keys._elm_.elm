module Data.Keys exposing
    ( Event, Config, Cmd(..), allCmds, QuickKey
    , defaultConfig
    , eventDecoder, configDecoder
    , encodeConfig
    , initCmdLookUp, initQuickKeysLookUp
    )

{-| Keys Module for CtPaint Project


# Types

@docs Event, Config, Cmd, allCmds, QuickKey


# Default

@docs defaultConfig


# Decoders

@docs eventDecoder, configDecoder


# Encoders

@docs encodeConfig


# Init

@docs initCmdLookUp, initQuickKeysLookUp

-}

import Data.Browser exposing (Browser)
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Keyboard exposing (Key(..))
import String.Extra



-- TYPES --


{-| Events represent key board events
-}
type alias Event =
    { code : Int
    , meta : Bool
    , ctrl : Bool
    , shift : Bool
    , direction : Direction
    }


{-| The direction union type represents whether the key event was a down press or a key release
-}
type Direction
    = Up
    | Down


{-| Cmds are things particular key strokes can execute
-}
type Cmd
    = SwatchesTurnLeft
    | SwatchesTurnRight
    | SwatchesQuickTurnLeft
    | RevertQuickTurnLeft
    | SwatchesQuickTurnRight
    | RevertQuickTurnRight
    | SwatchesQuickTurnDown
    | RevertQuickTurnDown
    | SetToolToPencil
    | SetToolToHand
    | SetToolToSelect
    | SetToolToFill
    | SetToolToEraser
    | SetToolToSample
    | SetToolToLine
    | SetToolToRectangle
    | SetToolToRectangleFilled
    | Undo
    | Redo
    | Cut
    | Copy
    | SelectAll
    | Paste
    | ZoomIn
    | ZoomOut
    | InitDownload
    | InitImport
    | InitScale
    | InitText
    | InitReplaceColor
    | ToggleColorPicker
    | SwitchGalleryView
    | ToggleMinimap
    | Delete
    | FlipHorizontal
    | FlipVertical
    | Rotate90
    | Rotate180
    | Rotate270
    | InvertColors
    | Save
    | SetTransparency
    | InitUpload
    | InitResize
      -- WHEN ADDING A CMD, add it to defaultConfig, allCmds, and the Cmd type
    | NoCmd


{-| A list of all the cmds
-}
allCmds : List Cmd
allCmds =
    [ SwatchesTurnLeft
    , SwatchesTurnRight
    , SwatchesQuickTurnLeft
    , RevertQuickTurnLeft
    , SwatchesQuickTurnRight
    , RevertQuickTurnRight
    , SwatchesQuickTurnDown
    , RevertQuickTurnDown
    , SetToolToPencil
    , SetToolToHand
    , SetToolToSelect
    , SetToolToFill
    , SetToolToEraser
    , SetToolToSample
    , SetToolToLine
    , SetToolToRectangle
    , SetToolToRectangleFilled
    , Undo
    , Redo
    , Cut
    , Copy
    , SelectAll
    , Paste
    , ZoomIn
    , ZoomOut
    , InitDownload
    , InitImport
    , InitScale
    , InitText
    , InitReplaceColor
    , ToggleColorPicker
    , SwitchGalleryView
    , ToggleMinimap
    , Delete
    , FlipHorizontal
    , FlipVertical
    , Rotate90
    , Rotate180
    , Rotate270
    , InvertColors
    , Save
    , SetTransparency
    , InitUpload
    , InitResize

    -- Includes every constructor except NoCmd
    -- WHEN ADDING A CMD, add it to defaultConfig, allCmds, and the Cmd type
    ]


type CmdKeyState
    = CmdKeyIsDown
    | CmdKeyIsUp


type ShiftState
    = ShiftIsDown
    | ShiftIsUp


{-| Certain keys execute certain cmds. Those key combinations need to be represented to the user, the QuickKey type represents that
-}
type alias QuickKey =
    { direction : Direction
    , key : Key
    , cmd : CmdKeyState
    , shift : ShiftState
    }


{-| A config represents the full specification of keys a user presses to issue which cmds
-}
type alias Config =
    List ( QuickKey, Cmd )


{-| Users must start with some kind of config. This is the default one they start off with
-}
defaultConfig : List ( QuickKey, Cmd )
defaultConfig =
    [ QuickKey (Down Number2 CmdKeyIsUp ShiftIsUp) SwatchesQuickTurnLeft
    , QuickKey (Down Number3 CmdKeyIsUp ShiftIsUp) SwatchesQuickTurnDown
    , QuickKey (Down Number4 CmdKeyIsUp ShiftIsUp) SwatchesQuickTurnRight
    , QuickKey (Down Number1 CmdKeyIsUp ShiftIsUp) SwatchesTurnLeft
    , QuickKey (Up Number2 CmdKeyIsUp) ShiftIsUp RevertQuickTurnLeft
    , QuickKey (Up Number3 CmdKeyIsUp ShiftIsUp) RevertQuickTurnDown
    , QuickKey (Up Number4 CmdKeyIsUp ShiftIsUp) RevertQuickTurnRight
    , QuickKey (Down Number5 CmdKeyIsUp ShiftIsUp) SwatchesTurnRight
    , QuickKey (Down CharP CmdKeyIsUp ShiftIsUp) SetToolToPencil
    , QuickKey (Down CharH CmdKeyIsUp ShiftIsUp) SetToolToHand
    , QuickKey (Down CharS CmdKeyIsUp ShiftIsUp) SetToolToSelect
    , QuickKey (Down CharG CmdKeyIsUp ShiftIsUp) SetToolToFill
    , QuickKey (Down CharE CmdKeyIsUp ShiftIsUp) SetToolToEraser
    , QuickKey (Down CharI CmdKeyIsUp ShiftIsUp) SetToolToSample
    , QuickKey (Down CharL CmdKeyIsUp ShiftIsUp) SetToolToLine
    , QuickKey (Down CharU CmdKeyIsUp ShiftIsUp) SetToolToRectangle
    , QuickKey (Down CharJ CmdKeyIsUp ShiftIsUp) SetToolToRectangleFilled
    , QuickKey (Down CharZ CmdKeyIsDown ShiftIsUp) Undo
    , QuickKey (Down CharY CmdKeyIsDown ShiftIsUp) Redo
    , QuickKey (Down CharC CmdKeyIsDown ShiftIsUp) Copy
    , QuickKey (Down CharX CmdKeyIsDown ShiftIsUp) Cut
    , QuickKey (Down CharV CmdKeyIsDown ShiftIsUp) Paste
    , QuickKey (Down CharA CmdKeyIsDown ShiftIsUp) SelectAll
    , QuickKey (Down Equals CmdKeyIsUp ShiftIsUp) ZoomIn
    , QuickKey (Down Minus CmdKeyIsUp ShiftIsUp) ZoomOut
    , QuickKey (Down BackQuote CmdKeyIsUp ShiftIsUp) ToggleMinimap
    , QuickKey (Down CharD CmdKeyIsUp ShiftIsDown) InitDownload
    , QuickKey (Down CharI CmdKeyIsDown ShiftIsUp) InitImport
    , QuickKey (Down CharD CmdKeyIsDown ShiftIsDown) InitScale
    , QuickKey (Down CharT CmdKeyIsUp ShiftIsUp) InitText
    , QuickKey (Down CharR CmdKeyIsUp ShiftIsUp) InitReplaceColor
    , QuickKey (Down Tab CmdKeyIsUp ShiftIsUp) SwitchGalleryView
    , QuickKey (Down BackSpace CmdKeyIsUp ShiftIsUp) Delete
    , QuickKey (Down CharE CmdKeyIsDown ShiftIsDown) ToggleColorPicker
    , QuickKey (Down CharH CmdKeyIsUp ShiftIsDown) FlipHorizontal
    , QuickKey (Down CharV CmdKeyIsUp ShiftIsDown) FlipVertical
    , QuickKey (Down CharR CmdKeyIsUp ShiftIsDown) Rotate90
    , QuickKey (Down CharF CmdKeyIsUp ShiftIsDown) Rotate180
    , QuickKey (Down CharE CmdKeyIsUp ShiftIsDown) Rotate270
    , QuickKey (Down CharI CmdKeyIsUp ShiftIsDown) InvertColors
    , QuickKey (Down Space CmdKeyIsUp ShiftIsUp) SetTransparency
    , QuickKey (Down CharO CmdKeyIsDown ShiftIsUp) InitUpload
    , QuickKey (Down CharR CmdKeyIsDown ShiftIsDown) InitResize

    -- WHEN ADDING A CMD, add it to defaultConfig, allCmds, and the Cmd type
    ]



-- Cmd Look Up --


{-| The dictionary used to map key events to cmds
-}
initCmdLookUp : Browser -> Config -> Dict String Cmd
initCmdLookUp browser =
    List.map (Tuple.mapFirst (quickKeyToString browser))
        >> Dict.fromList


{-| The dictionary used to map cmds to key arrangements (Undo -> "cmd + z")
-}
initQuickKeysLookUp : Browser -> Config -> Bool -> Dict String String
initQuickKeysLookUp browser config isMac =
    config
        |> List.map (quickKeyLookUp browser isMac)
        |> Dict.fromList


quickKeyLookUp : Browser -> Bool -> ( QuickKey, Cmd ) -> ( String, String )
quickKeyLookUp browser isMac ( ( _, key, cmdKey, shift ), command ) =
    let
        commandStr =
            Basics.toString command

        cmdKeyStr =
            case ( cmdKey, isMac ) of
                ( CmdKeyIsDown, True ) ->
                    "Cmd + "

                ( CmdKeyIsDown, False ) ->
                    "Ctrl + "

                _ ->
                    ""

        shiftStr =
            if shift == ShiftIsDown then
                "Shift + "

            else
                ""

        keyStr =
            key
                |> Keyboard.Extra.Browser.toCode browser
                |> keyCodeToString browser
    in
    ( commandStr, cmdKeyStr ++ shiftStr ++ keyStr )


quickKeyToString : Browser -> QuickKey -> String
quickKeyToString browser ( direction, key, cmd, shift ) =
    [ shift == ShiftIsDown |> Basics.toString
    , cmd == CmdKeyIsDown |> Basics.toString
    , Keyboard.Extra.Browser.toCode browser key |> Basics.toString
    , Basics.toString direction
    ]
        |> String.concat


keyCodeToString : Browser -> KeyCode -> String
keyCodeToString browser key =
    case Keyboard.Extra.Browser.fromCode browser key of
        Control ->
            "Ctrl"

        QuestionMark ->
            "?"

        Equals ->
            "="

        Minus ->
            "-"

        Semicolon ->
            ";"

        Super ->
            "Cmd"

        Asterisk ->
            "*"

        Comma ->
            ","

        Dollar ->
            "$"

        BackQuote ->
            "`"

        other ->
            let
                otherAsStr =
                    Basics.toString other

                isChar =
                    String.left 4 otherAsStr == "Char"

                isNumber =
                    String.left 6 otherAsStr == "Number"
            in
            case ( isChar, isNumber ) of
                ( True, _ ) ->
                    String.right 1 otherAsStr

                ( _, True ) ->
                    String.right 1 otherAsStr

                _ ->
                    otherAsStr



-- ENCODER --


{-| Turn the config into json
-}
encodeConfig : Browser -> Config -> Value
encodeConfig browser =
    List.map (encodeCmdPair browser) >> Encode.list


encodeCmdPair : Browser -> ( QuickKey, Cmd ) -> Value
encodeCmdPair browser ( quickKey, cmd ) =
    [ "quick-key" := encodeQuickKey browser quickKey
    , "cmd" := simpleEncode cmd
    ]
        |> Encode.object


encodeQuickKey : Browser -> QuickKey -> Value
encodeQuickKey browser ( direction, key, cmdKeyState, shiftState ) =
    [ "direction" := simpleEncode direction
    , "key" := encodeKey browser key
    , "cmd-key-state" := encodeCmdKeyState cmdKeyState
    , "shift-state" := encodeShiftState shiftState
    ]
        |> Encode.object


encodeKey : Browser -> Key -> Value
encodeKey browser =
    Keyboard.Extra.Browser.toCode browser >> Encode.int


encodeCmdKeyState : CmdKeyState -> Value
encodeCmdKeyState cmdKeyState =
    case cmdKeyState of
        CmdKeyIsDown ->
            simpleEncode Down

        CmdKeyIsUp ->
            simpleEncode Up


encodeShiftState : ShiftState -> Value
encodeShiftState shiftState =
    case shiftState of
        ShiftIsDown ->
            simpleEncode Down

        ShiftIsUp ->
            simpleEncode Up



-- DECODER --


{-| The decoder for key events
-}
eventDecoder : Decoder Event
eventDecoder =
    decode Event
        |> required "keyCode" Decode.int
        |> required "meta" Decode.bool
        |> required "ctrl" Decode.bool
        |> required "shift" Decode.bool
        |> required "direction" directionDecoder


directionDecoder : Decoder Direction
directionDecoder =
    Decode.string
        |> Decode.andThen toDirection


toDirection : String -> Decoder Direction
toDirection str =
    case str of
        "up" ->
            Decode.succeed Up

        "down" ->
            Decode.succeed Down

        _ ->
            Decode.fail "Direction not up or down"


{-| Turn json into a key config using the config decoder
-}
configDecoder : Browser -> Decoder Config
configDecoder =
    Decode.list << cmdPairDecoder


cmdPairDecoder : Browser -> Decoder ( QuickKey, Cmd )
cmdPairDecoder browser =
    decode Tupe.pair
        |> required "quick-key" (quickKeyDecoder browser)
        |> required "cmd" cmdDecoder


quickKeyDecoder : Browser -> Decoder QuickKey
quickKeyDecoder browser =
    decode QuickKey
        |> required "direction" directionDecoder
        |> required "key" (keyDecoder browser)
        |> required "cmd-key-state" cmdKeyStateDecoder
        |> required "shift-state" shiftStateDecoder


cmdDecoder : Decoder Cmd
cmdDecoder =
    Decode.string
        |> Decode.andThen toCmd


toString : Cmd -> String
toString cmd =
    case cmd of
        SwatchesTurnLeft ->
            "swatches-turn-left"

        SwatchesTurnRight ->
            "swatches-turn-right"

        SwatchesQuickTurnLeft ->
            "swatches-quick-turn-left"

        RevertQuickTurnLeft ->
            "revert-quick-turn-left"

        SwatchesQuickTurnRight ->
            "swatches-quick-turn-right"

        RevertQuickTurnRight ->
            "revert-quick-turn-right"

        SwatchesQuickTurnDown ->
            "swatches-quick-turn-down"

        RevertQuickTurnDown ->
            "revert-quick-turn-down"

        SetToolToPencil ->
            "set-tool-to-pencil"

        SetToolToHand ->
            "set-tool-to-hand"

        SetToolToSelect ->
            "set-tool-to-select"

        SetToolToFill ->
            "set-tool-to-fill"

        SetToolToSample ->
            "set-tool-to-sample"

        SetToolToLine ->
            "set-tool-to-line"

        SetToolToRectangle ->
            "set-tool-to-rectangle"

        SetToolToRectangleFilled ->
            "set-tool-to-rectangle-filled"

        SetToolToEraser ->
            "set-tool-to-eraser"

        SetTransparency ->
            "set-transparency"

        Undo ->
            "undo"

        Redo ->
            "redo"

        Cut ->
            "cut"

        Copy ->
            "copy"

        SelectAll ->
            "select-all"

        Paste ->
            "paste"

        ZoomIn ->
            "zoom-in"

        ZoomOut ->
            "zoom-out"

        InitDownload ->
            "init-download"

        InitImport ->
            "init-import"

        InitScale ->
            "init-scale"

        InitText ->
            "init-text"

        InitReplaceColor ->
            "init-replace-color"

        InitResize ->
            "init-resize"

        InitUpload ->
            "init-upload"

        ToggleColorPicker ->
            "toggle-color-picker"

        SwitchGalleryView ->
            "switch-gallery-view"

        ToggleMinimap ->
            "toggle-minimap"

        Delete ->
            "delete"

        FlipHorizontal ->
            "flip-horizontal"

        FlipVertical ->
            "flip-vertical"

        Rotate90 ->
            "rotate90"

        Rotate180 ->
            "rotate180"

        Rotate270 ->
            "rotate270"

        InvertColors ->
            "invert-colors"

        Save ->
            "save"

        NoCmd ->
            "NO__COMMAND"


keyDict : Dict String Cmd
keyDict =
    List.map2
        Tuple.pair
        (List.map toString allCmds)
        allCmds
        |> Dict.fromList


toCmd : String -> Decoder Cmd
toCmd str =
    case Dict.get str keyDict of
        Just cmd ->
            Decode.succeed cmd

        Nothing ->
            Decode.fail ("unrecognized cmd -> " ++ str)


cmdKeyStateDecoder : Decoder CmdKeyState
cmdKeyStateDecoder =
    Decode.map toCmdKeyState directionDecoder


shiftStateDecoder : Decoder ShiftState
shiftStateDecoder =
    Decode.map toShiftState directionDecoder


toShiftState : Direction -> ShiftState
toShiftState direction =
    case direction of
        Up ->
            ShiftIsUp

        Down ->
            ShiftIsDown


toCmdKeyState : Direction -> CmdKeyState
toCmdKeyState direction =
    case direction of
        Up ->
            CmdKeyIsUp

        Down ->
            CmdKeyIsDown


keyDecoder : Browser -> Decoder Key
keyDecoder browser =
    Decode.map
        (Keyboard.Extra.Browser.fromCode browser)
        Decode.int
