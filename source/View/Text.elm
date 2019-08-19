module View.Text exposing
    ( Model
    , concat
    , config
    , fromString
    , withStyles
    )

import Css exposing (Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attr


type alias Model =
    { styles : List Style
    , value : String
    }


config : Model -> Html msg
config { styles, value } =
    Html.p
        [ Attr.css styles ]
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
        , value = str
        }
