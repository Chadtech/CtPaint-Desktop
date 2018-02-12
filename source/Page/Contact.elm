module Page.Contact
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2, point)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, br, div, p, textarea)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onInput)
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = FieldUpdated String
    | SendClicked


type alias Model =
    { field : String }



-- INIT --


init : Model
init =
    { field = "" }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated field ->
            { model | field = field }
                & Cmd.none

        SendClicked ->
            model & Cmd.none



-- STYLES --


type Class
    = TextContainer
    | CommentBox


css : Stylesheet
css =
    [ Css.class TextContainer
        [ width (px 800)
        , display block
        , margin auto
        ]
    , (Css.class CommentBox << List.append Html.Custom.indent)
        [ outline none
        , fontFamilies [ "hfnss" ]
        , fontSize (em 2)
        , backgroundColor backgroundx2
        , color point
        , width (px 486)
        , height (px 222)
        , marginBottom (px 8)
        , property "-webkit-font-smoothing" "none"
        ]
    ]
        |> namespace contactNamespace
        |> stylesheet


contactNamespace : String
contactNamespace =
    Html.Custom.makeNamespace "Contact"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace contactNamespace


view : Model -> List (Html Msg)
view model =
    [ words
    , textarea
        [ class [ CommentBox ]
        , onInput FieldUpdated
        , Attrs.spellcheck False
        ]
        [ Html.text model.field ]
    ]


words : Html Msg
words =
    [ comment0
    , email
    , comment1
    ]
        |> List.map p_
        |> List.intersperse (br [] [])
        |> div [ class [ TextContainer ] ]


comment0 : String
comment0 =
    """
    Send your  questions, comments, criticisms, and bug reports
    to..
    """


email : String
email =
    """
    ctpaint@programhouse.us
    """


comment1 : String
comment1 =
    """
    ..or fill out and submit the form below. I would love to hear from you!
    """


p_ : String -> Html msg
p_ str =
    p
        []
        [ Html.text str ]
