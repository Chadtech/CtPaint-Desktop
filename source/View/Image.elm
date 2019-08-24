module View.Image exposing
    ( Image
    , Option
    , config
    , logo
    , thirdParty
    , toHtml
    , withWidth
    )

import Css
import Data.MountPath as MountPath exposing (MountPath)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Image
    = Image Source (List Option)


type Source
    = Asset AssetSource MountPath
    | ThirdParty String


type AssetSource
    = Logo


type Option
    = Width Float


type alias Summary =
    { width : Maybe Float
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


logo : MountPath -> Source
logo =
    Asset Logo


thirdParty : String -> Source
thirdParty =
    ThirdParty


withWidth : Float -> Image -> Image
withWidth width =
    addOption (Width width)



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option -> Image -> Image
addOption option (Image params options) =
    Image params (option :: options)


optionsToSummary : List Option -> Summary
optionsToSummary =
    let
        modifySummary : Option -> Summary -> Summary
        modifySummary option summary =
            case option of
                Width width ->
                    { summary | width = Just width }
    in
    List.foldr
        modifySummary
        { width = Nothing
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



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : Source -> Image
config src =
    Image src []


toHtml : Image -> Html msg
toHtml (Image src options) =
    let
        summary : Summary
        summary =
            optionsToSummary options
    in
    Html.img
        [ Attrs.src (sourceToString src)
        , Attrs.css
            [ CssUtil.styleMaybe
                Style.exactWidth
                summary.width
            , Css.margin Css.auto
            ]
        ]
        []
