module View.Text exposing
    ( Model
    , asColor
    , colorSegments
    , concat
    , config
    , fromString
    , withStyles
    )

import Css exposing (Color, Style)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs


type alias Model =
    { styles : List Style
    , value : String
    }


config : Model -> Html msg
config { styles, value } =
    Html.p
        [ Attrs.css styles ]
        [ Html.text value ]


fromString : String -> Html msg
fromString =
    withStyles []


concat : List String -> Html msg
concat =
    withStyles [] << String.concat


asColor : Color -> String -> Html msg
asColor color =
    withStyles [ Css.color color ]


withStyles : List Style -> String -> Html msg
withStyles styles str =
    config
        { styles = styles
        , value = str
        }


colorSegments : List ( String, Maybe Color ) -> Html msg
colorSegments =
    let
        segmentView : ( String, Maybe Color ) -> Html msg
        segmentView ( text, maybeColor ) =
            case maybeColor of
                Just color ->
                    Html.span
                        [ Attrs.css [ Css.color color ] ]
                        [ Html.text text ]

                Nothing ->
                    Html.text text
    in
    Html.p [] << List.map segmentView
