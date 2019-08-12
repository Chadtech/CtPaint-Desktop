module Page.Contact exposing
    ( Model
    , Msg
    , css
    , init
    , track
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Data.Tracking as Tracking
import Html exposing (Html, a, div, p, span, textarea)
import Html.Attributes as Attrs
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode



-- TYPES --


type Msg
    = FieldUpdated String
    | SendClicked


type alias Model =
    { field : String
    , sendClicked : Bool
    }



-- INIT --


init : Model
init =
    { field = ""
    , sendClicked = False
    }



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        FieldUpdated field ->
            if model.sendClicked then
                model

            else
                { model | field = field }

        SendClicked ->
            -- Nothing happens here,
            -- because the actual comment
            -- is recorded in a tracking
            -- event
            { model | sendClicked = True }



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        SendClicked ->
            [ def "comment" <| Encode.string model.field ]
                |> def "submit click"
                |> Just

        FieldUpdated _ ->
            Nothing



-- STYLES --


type Class
    = TextContainer
    | CommentBox
    | Disabled
    | SendButton
    | Email


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
        , backgroundColor Ct.background2
        , color Ct.point0
        , width (px 800)
        , padding (px 8)
        , height (px 300)
        , marginBottom (px 8)
        , property "-webkit-font-smoothing" "none"
        , display block
        , margin auto
        , marginTop (px 8)
        , resize none
        , withClass Disabled
            [ backgroundColor Ct.ignorable1 ]
        ]
    , Css.class SendButton
        [ display block
        , margin auto
        , marginTop (px 8)
        , maxWidth maxContent
        , withClass Disabled
            [ hover [ color Ct.point0 ]
            , backgroundColor Ct.ignorable1
            ]
        ]
    , Css.class Email
        [ color Ct.important0 ]
    ]
        |> namespace contactNamespace
        |> stylesheet


contactNamespace : String
contactNamespace =
    Html.Custom.makeNamespace "Contact"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace contactNamespace


view : Model -> List (Html Msg)
view model =
    [ words
    , textarea
        [ classList
            [ ( CommentBox, True )
            , ( Disabled, model.sendClicked )
            ]
        , onInput FieldUpdated
        , Attrs.spellcheck False
        , Attrs.value (commentBoxText model)
        , Attrs.placeholder "enter your comment here"
        ]
        []
    , a
        [ classList
            [ ( SendButton, True )
            , ( Disabled, model.sendClicked )
            ]
        , onClick SendClicked
        ]
        [ Html.text "send" ]
    ]


commentBoxText : Model -> String
commentBoxText model =
    if model.sendClicked then
        "Sent! Thank you"

    else
        model.field


words : Html Msg
words =
    div
        [ class [ TextContainer ] ]
        [ p
            []
            [ Html.text comment0
            , span
                [ class [ Email ] ]
                [ Html.text email ]
            , Html.text comment1
            ]
        ]


comment0 : String
comment0 =
    """
    Send your  questions, comments, criticisms, and bug reports
    to
    """


email : String
email =
    """
    ctpaint@programhouse.us
    """


comment1 : String
comment1 =
    """
    or fill out and submit the form below. I would love to hear from you!
    """
