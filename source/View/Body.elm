module View.Body exposing
    ( NavItem
    , leftNavView
    , navItem
    , singleColumnView
    , view
    )

import Chadtech.Colors as Colors
import Css exposing (Style)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Style
import View.Button as Button exposing (Button)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type NavItem msg
    = NavItem (Button msg)



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


unwrapNavItem : NavItem msg -> Button msg
unwrapNavItem (NavItem html) =
    html



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : List Style -> List (Html msg) -> List (Html msg)
view extraStyles children =
    [ Grid.box
        [ Css.backgroundColor Colors.content1
        , Style.fullWidth
        , Css.flex (Css.int 1)
        , Style.centerContent
        , Css.batch extraStyles
        , Style.scroll
        ]
        children
    ]


singleColumnView : List Style -> List (Html msg) -> List (Html msg)
singleColumnView styles =
    view
        [ Style.width 10
        , Css.flex Css.none
        , Css.flexDirection Css.column
        , Css.batch styles
        ]


navItem :
    { onClick : msg
    , label : String
    , active : Bool
    }
    -> NavItem msg
navItem { onClick, label, active } =
    Button.config
        onClick
        label
        |> Button.indent active
        |> Button.asFullWidth
        |> NavItem


leftNavView :
    { navItems : List (NavItem msg)
    , content : List (Html msg)
    , styles : List Style
    , headerRows : List (Html msg)
    }
    -> List (Html msg)
leftNavView { navItems, content, styles, headerRows } =
    singleColumnView
        styles
        (headerRows
            ++ [ Grid.row
                    []
                    [ Grid.column
                        [ Grid.exactWidthColumn (Style.sizePx 7)
                        , Css.flexDirection Css.column
                        ]
                        (Button.column <| List.map unwrapNavItem navItems)
                    , Grid.column
                        [ Style.sectionMarginLeft
                        , Css.flexDirection Css.column
                        ]
                        content
                    ]
               ]
        )
