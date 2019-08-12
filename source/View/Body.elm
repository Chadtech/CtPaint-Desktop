module View.Body exposing
    ( Body
    , Option
    , config
    , singleColumnWidth
    , toHtml
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import Util.Css as CssUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Body msg
    = Body (List Option) (List (Html msg))


type Option
    = SingleColumnWidth



-------------------------------------------------------------------------------
-- HELPERS --
-------------------------------------------------------------------------------


singleColumnWidth : Body msg -> Body msg
singleColumnWidth =
    addOption SingleColumnWidth


addOption : Option -> Body msg -> Body msg
addOption option (Body options children) =
    Body (option :: options) children



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : List (Html msg) -> Body msg
config =
    Body []


toHtml : Body msg -> Html msg
toHtml (Body options children) =
    let
        width : Style
        width =
            if List.member SingleColumnWidth options then
                Style.width Style.i9

            else
                CssUtil.noStyle
    in
    Grid.row
        [ Css.backgroundColor Colors.content1
        , Style.fullWidth
        , Css.flex (Css.int 1)
        , Style.centerContent
        ]
        [ Grid.column
            [ width
            , Css.flex Css.none
            , Css.flexDirection Css.column
            ]
            children
        ]
