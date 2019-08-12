module View.Text exposing
    ( Model
    , concat
    , config
    , fromString
    , onClick
    , withStyles
    )

import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events


type alias Model msg =
    { styles : List Style
    , options : List (Option msg)
    , value : String
    }


type Option msg
    = Option (Attribute msg)


unwrapOption : Option msg -> Attribute msg
unwrapOption (Option attr) =
    attr


onClick : msg -> Option msg
onClick =
    Option << Events.onClick


config : Model msg -> Html msg
config { styles, options, value } =
    Html.p
        (Attr.css styles :: List.map unwrapOption options)
        [ Html.text value ]


fromString : String -> Html msg
fromString =
    withStyles []


concat : List String -> Html msg
concat =
    withStyles [] << String.concat


withStyles : List Style -> String -> Html msg
withStyles styles str =
    config
        { styles = styles
        , options = []
        , value = str
        }
