module Page.Contact exposing
    ( Model
    , Msg
    , getSession
    , getUser
    , init
    , mapSession
    , track
    , update
    , view
    )

import Data.Document exposing (Document)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Session exposing (Session)
import Util.Cmd as CmdUtil
import Util.String as StringUtil



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type Msg
    = FieldUpdated String
    | SendClicked


type alias Model =
    { session : Session
    , user : User
    , field : String
    , sent : Bool
    }



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> Model
init session user =
    { session = session
    , user = user
    , field = ""
    , sent = False
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setField : String -> Model -> Model
setField newField model =
    { model | field = newField }


sent : Model -> Model
sent model =
    { model | sent = True }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        FieldUpdated field ->
            if model.sent then
                model
                    |> CmdUtil.withNoCmd

            else
                model
                    |> setField field
                    |> CmdUtil.withNoCmd

        SendClicked ->
            if StringUtil.isBlank model.field then
                model
                    |> CmdUtil.withNoCmd

            else
                ( sent model
                  -- TODO, wire this up
                , Tracking.event "comment"
                    |> Tracking.withString "value" model.field
                    |> Tracking.send
                )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        SendClicked ->
            Tracking.event "submit click"

        FieldUpdated _ ->
            Nothing



-- STYLES --
--
--
--type Class
--    = TextContainer
--    | CommentBox
--    | Disabled
--    | SendButton
--    | Email
--
--
--css : Stylesheet
--css =
--    [ Css.class TextContainer
--        [ width (px 800)
--        , display block
--        , margin auto
--        ]
--    , (Css.class CommentBox << List.append Html.Custom.indent)
--        [ outline none
--        , fontFamilies [ "hfnss" ]
--        , fontSize (em 2)
--        , backgroundColor Ct.background2
--        , color Ct.point0
--        , width (px 800)
--        , padding (px 8)
--        , height (px 300)
--        , marginBottom (px 8)
--        , property "-webkit-font-smoothing" "none"
--        , display block
--        , margin auto
--        , marginTop (px 8)
--        , resize none
--        , withClass Disabled
--            [ backgroundColor Ct.ignorable1 ]
--        ]
--    , Css.class SendButton
--        [ display block
--        , margin auto
--        , marginTop (px 8)
--        , maxWidth maxContent
--        , withClass Disabled
--            [ hover [ color Ct.point0 ]
--            , backgroundColor Ct.ignorable1
--            ]
--        ]
--    , Css.class Email
--        [ color Ct.important0 ]
--    ]
--        |> namespace contactNamespace
--        |> stylesheet
--
--
--contactNamespace : String
--contactNamespace =
--    Html.Custom.makeNamespace "Contact"
-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    { title = Just "contact"
    , body =
        []
    }



--    [ words
--    , textarea
--        [ classList
--            [ ( CommentBox, True )
--            , ( Disabled, model.sendClicked )
--            ]
--        , onInput FieldUpdated
--        , Attrs.spellcheck False
--        , Attrs.value (commentBoxText model)
--        , Attrs.placeholder "enter your comment here"
--        ]
--        []
--    , a
--        [ classList
--            [ ( SendButton, True )
--            , ( Disabled, model.sendClicked )
--            ]
--        , onClick SendClicked
--        ]
--        [ Html.text "send" ]
--    ]
--
--
--commentBoxText : Model -> String
--commentBoxText model =
--    if model.sendClicked then
--        "Sent! Thank you"
--
--    else
--        model.field
--
--
--words : Html Msg
--words =
--    div
--        [ class [ TextContainer ] ]
--        [ p
--            []
--            [ Html.text comment0
--            , span
--                [ class [ Email ] ]
--                [ Html.text email ]
--            , Html.text comment1
--            ]
--        ]
--
--
--comment0 : String
--comment0 =
--    """
--    Send your  questions, comments, criticisms, and bug reports
--    to
--    """
--
--
--email : String
--email =
--    """
--    ctpaint@programhouse.us
--    """
--
--
--comment1 : String
--comment1 =
--    """
--    or fill out and submit the form below. I would love to hear from you!
--    """
