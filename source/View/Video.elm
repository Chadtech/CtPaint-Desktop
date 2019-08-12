module View.Video exposing
    ( Source
    , Video
    , asFullWidth
    , config
    , sourceToString
    , splash
    , toHtml
    )

import Css exposing (Style)
import Data.MountPath as MountPath exposing (MountPath)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Video
    = Video Source (List Option)


type Option
    = FullWidth


type Source
    = Splash MountPath



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


asFullWidth : Video -> Video
asFullWidth =
    addOption FullWidth


splash : MountPath -> Source
splash =
    Splash



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


addOption : Option -> Video -> Video
addOption option (Video source options) =
    Video source (option :: options)


sourceToString : Source -> String
sourceToString source =
    case source of
        Splash mountPath ->
            MountPath.path mountPath [ "splash-video.mp4" ]



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : Source -> Video
config source =
    Video source []


toHtml : Video -> Html msg
toHtml (Video source options) =
    let
        height : Style
        height =
            if List.member FullWidth options then
                Style.fullWidth

            else
                CssUtil.noStyle
    in
    Html.video
        [ Attrs.src (sourceToString source)
        , Attrs.autoplay True
        , Attrs.loop True
        , Attrs.css [ height ]
        ]
        []
