module View.Image exposing
    ( Image
    , Option
    , config
    , drawing
    , logo
    , onClick
    , thirdParty
    , toHtml
    , withStyles
    , withWidth
    )

import Css
import Data.Drawing as Drawing exposing (Drawing)
import Data.MountPath as MountPath exposing (MountPath)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Image msg
    = Image Source (List (Option msg))


type Source
    = Asset AssetSource MountPath
    | Drawing Drawing
    | ThirdParty String


type AssetSource
    = Logo


type Option msg
    = Width Float
    | Styles (List Css.Style)
    | OnClick msg


type alias Summary msg =
    { width : Maybe Float
    , extraStyles : List Css.Style
    , onClick : Maybe msg
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


drawing : Drawing -> Source
drawing =
    Drawing


logo : MountPath -> Source
logo =
    Asset Logo


thirdParty : String -> Source
thirdParty =
    ThirdParty


withWidth : Float -> Image msg -> Image msg
withWidth width =
    addOption (Width width)


withStyles : List Css.Style -> Image msg -> Image msg
withStyles =
    addOption << Styles


onClick : msg -> Image msg -> Image msg
onClick =
    addOption << OnClick



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option msg -> Image msg -> Image msg
addOption option (Image params options) =
    Image params (option :: options)


optionsToSummary : List (Option msg) -> Summary msg
optionsToSummary =
    let
        modifySummary : Option msg -> Summary msg -> Summary msg
        modifySummary option summary =
            case option of
                Width width ->
                    { summary | width = Just width }

                Styles list ->
                    { summary | extraStyles = list ++ summary.extraStyles }

                OnClick msg ->
                    { summary | onClick = Just msg }
    in
    List.foldr
        modifySummary
        { width = Nothing
        , extraStyles = []
        , onClick = Nothing
        }


sourceToString : Source -> String
sourceToString source =
    case source of
        Asset assetSource mountPath ->
            let
                mount : String -> String
                mount path =
                    MountPath.path mountPath [ path ]
            in
            case assetSource of
                Logo ->
                    mount "splash-image.png"

        ThirdParty url ->
            url

        Drawing drawing_ ->
            drawing_
                |> Drawing.getPublicId
                |> Drawing.getDrawingUrl



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : Source -> Image msg
config src =
    Image src []


toHtml : Image msg -> Html msg
toHtml (Image src options) =
    let
        summary : Summary msg
        summary =
            optionsToSummary options

        attrs : List (Attribute msg)
        attrs =
            [ Attrs.src (sourceToString src)
            , Attrs.css
                [ CssUtil.styleMaybe
                    Style.exactWidth
                    summary.width
                , Css.margin Css.auto
                , Css.batch summary.extraStyles
                , CssUtil.styleIf
                    (summary.onClick /= Nothing)
                    Style.pointer
                ]
            ]

        conditionalAttrs : List (Attribute msg)
        conditionalAttrs =
            [ Maybe.map Events.onClick summary.onClick ]
                |> List.filterMap identity
    in
    Html.img
        (attrs ++ conditionalAttrs)
        []
