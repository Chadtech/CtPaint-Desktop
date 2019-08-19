module View.Link exposing
    ( Link
    , Option
    , config
    , toHtml
    )

-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------

import Chadtech.Colors as Colors
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Style


type Link msg
    = Link (Model msg) (List Option)


type alias Model msg =
    { onClick : msg
    , label : String
    }


type Option
    = Option


type alias Summary =
    {}



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


optionsToSummary : List Option -> Summary
optionsToSummary =
    let
        modifySummary : Option -> Summary -> Summary
        modifySummary option summary =
            case option of
                Option ->
                    summary
    in
    List.foldr modifySummary {}



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


config : msg -> String -> Link msg
config onClick label =
    Link
        { onClick = onClick
        , label = label
        }
        []


toHtml : Link msg -> Html msg
toHtml (Link { onClick, label } options) =
    let
        summary : Summary
        summary =
            optionsToSummary options
    in
    Html.button
        [ Attrs.css
            [ Style.height 5
            , Css.color Colors.important0
            , Css.hover [ Css.color Colors.important1 ]
            , Style.noBackground
            , Style.noBorder
            ]
        , Events.onClick onClick
        ]
        [ Html.text label ]
