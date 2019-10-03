module Ui.Toolbar exposing
    ( ActionOption(..)
    , MenuOption(..)
    , Msg(..)
    , Option(..)
    , ToolOption(..)
    , initToolFromOption
    , optionFromTool
    , track
    , view
    )

import Data.Tool as Tool exposing (Tool)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Html.Styled.Lazy as HtmlLazy
import Style
import View.Button as Button



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Msg
    = OptionClicked Option
    | IncreaseEraserClicked
    | DecreaseEraserClicked


type Option
    = ToolOption ToolOption
    | MenuOption MenuOption
    | ActionOption ActionOption


type ActionOption
    = Invert
    | Transparency


type MenuOption
    = Text
    | Replace


type ToolOption
    = Hand
    | Sample
    | Fill
    | Select
    | ZoomIn
    | ZoomOut
    | Pencil
    | Line
    | Rectangle
    | RectangleFilled
    | Eraser



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


allToolOptions : List ToolOption
allToolOptions =
    let
        typeCheckingReminder : ToolOption -> ()
        typeCheckingReminder option =
            case option of
                Hand ->
                    ()

                Sample ->
                    ()

                Fill ->
                    ()

                Select ->
                    ()

                ZoomIn ->
                    ()

                ZoomOut ->
                    ()

                Pencil ->
                    ()

                Line ->
                    ()

                Rectangle ->
                    ()

                RectangleFilled ->
                    ()

                Eraser ->
                    ()
    in
    [ Select
    , ZoomIn
    , ZoomOut
    , Hand
    , Sample
    , Fill
    , Eraser
    , Pencil
    , Line
    , Rectangle
    , RectangleFilled
    ]


toolOptionToLabel : ToolOption -> String
toolOptionToLabel toolOption =
    case toolOption of
        Hand ->
            "hand"

        Sample ->
            "sample"

        Fill ->
            "fill"

        Select ->
            "select"

        ZoomIn ->
            "zoom in"

        ZoomOut ->
            "zoom out"

        Pencil ->
            "pencil"

        Line ->
            "line"

        Rectangle ->
            "rectangle"

        RectangleFilled ->
            "rectangle filled"

        Eraser ->
            "eraser"


toolOptionToComparable : ToolOption -> String
toolOptionToComparable =
    toolOptionToLabel


optionToTrackingString : Option -> String
optionToTrackingString option =
    case option of
        ToolOption toolOption ->
            toolOptionToLabel toolOption

        MenuOption menuOption ->
            case menuOption of
                Text ->
                    "text"

                Replace ->
                    "replace"

        ActionOption actionOption ->
            case actionOption of
                Invert ->
                    "invert"

                Transparency ->
                    "transparency"


toolOptionToIcon : ToolOption -> Int
toolOptionToIcon option =
    case option of
        Hand ->
            --"\xEA0A"
            59914

        Sample ->
            --"\xEA08"
            59912

        Fill ->
            --"\xEA16"
            59926

        Pencil ->
            --"\xEA02"
            59906

        Line ->
            --"\xEA09"
            59913

        Rectangle ->
            --"\xEA03"
            59907

        RectangleFilled ->
            --"\xEA04"
            59908

        Select ->
            --"\xEA07"
            59911

        ZoomIn ->
            --"\xEA17"
            59927

        ZoomOut ->
            --"\xEA18"
            59928

        Eraser ->
            --"\xEA1B"
            59931



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


initToolFromOption : ToolOption -> Tool
initToolFromOption toolOption =
    case toolOption of
        Hand ->
            Tool.initHand

        Sample ->
            Tool.initSample

        Fill ->
            Tool.initFill

        Select ->
            Tool.initSelect

        ZoomIn ->
            Tool.initZoomIn

        ZoomOut ->
            Tool.initZoomOut

        Pencil ->
            Tool.initPencil

        Line ->
            Tool.initLine

        Rectangle ->
            Tool.initRectangle

        RectangleFilled ->
            Tool.initRectangleFilled

        Eraser ->
            Tool.initEraser


optionFromTool : Tool -> ToolOption
optionFromTool tool =
    case tool of
        Tool.Hand _ ->
            Hand

        Tool.Sample ->
            Sample

        Tool.Fill ->
            Fill

        Tool.Select _ ->
            Select

        Tool.ZoomIn ->
            ZoomIn

        Tool.ZoomOut ->
            ZoomOut

        Tool.Pencil _ ->
            Pencil

        Tool.Line _ ->
            Line

        Tool.Rectangle _ ->
            Rectangle

        Tool.RectangleFilled _ ->
            RectangleFilled

        Tool.Eraser _ ->
            Eraser



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : { eraserSize : Int, toolOption : ToolOption } -> Grid.Column Msg
view { eraserSize, toolOption } =
    Grid.column
        [ Grid.columnShrink
        , Style.buttonPaddingHorizontal
        ]
        [ HtmlLazy.lazy2
            viewLazy
            eraserSize
            (toolOptionToComparable toolOption)
        ]


viewLazy : Int -> String -> Html Msg
viewLazy eraserSize currentToolOption =
    let
        optionViews : List (Html Msg)
        optionViews =
            [ List.map (toolOptionView currentToolOption) allToolOptions ]
                |> List.concat
    in
    Grid.box
        [ Style.width 5
        , Style.fullHeight
        ]
        optionViews


toolOptionView : String -> ToolOption -> Html Msg
toolOptionView currentToolOption thisOption =
    let
        iconStr : String
        iconStr =
            thisOption
                |> toolOptionToIcon
                |> Char.fromCode
                |> String.fromChar

        selected : Bool
        selected =
            currentToolOption == toolOptionToComparable thisOption
    in
    Grid.row
        [ Style.buttonMarginBottom ]
        [ Grid.column
            []
            [ Button.icon
                (OptionClicked (ToolOption thisOption))
                iconStr
                |> Button.indent selected
                |> Button.toHtml
            ]
        ]



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        OptionClicked option ->
            Tracking.event "option clicked"
                |> Tracking.withString "option" (optionToTrackingString option)

        IncreaseEraserClicked ->
            Tracking.event "increment eraser clicked"

        DecreaseEraserClicked ->
            Tracking.event "decrement eraser clicked"
