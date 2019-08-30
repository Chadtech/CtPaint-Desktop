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

import Chadtech.Colors as Colors
import Data.Document exposing (Document)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Session exposing (Session)
import Style
import Util.Cmd as CmdUtil
import Util.String as StringUtil
import View.Body as Body
import View.Button as Button
import View.ButtonRow as ButtowRow
import View.Text as Text
import View.TextArea as TextArea



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


canSend : Model -> Bool
canSend model =
    not <| StringUtil.isBlank model.field



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
            if canSend model then
                ( sent model
                , Tracking.event "comment"
                    |> Tracking.withString "value" model.field
                    |> Tracking.send
                )

            else
                model
                    |> CmdUtil.withNoCmd


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
    let
        email : String
        email =
            getSession model
                |> Session.getContactEmail
    in
    { title = Just "contact"
    , body =
        Body.singleColumnView
            [ Grid.row
                [ Style.marginTop 3 ]
                [ Grid.column
                    []
                    [ mainMessage email ]
                ]
            , Grid.row
                [ Style.marginVertical 3 ]
                [ Grid.column
                    [ Style.height 9 ]
                    (commentBox model)
                ]
            , ButtowRow.view
                [ Button.config
                    SendClicked
                    "send"
                    |> Button.isDisabled
                        (model.sent || (not <| canSend model))
                ]
            ]
    }


mainMessage : String -> Html msg
mainMessage email =
    Text.colorSegments
        [ ( """
        Send your  questions, comments, criticisms, and bug reports
        to
        """, Nothing )
        , ( email
          , Just Colors.important0
          )
        , ( """
        or fill out and submit the form below. I would love to hear from you!
        """
          , Nothing
          )
        ]


commentBox : Model -> List (Html Msg)
commentBox model =
    let
        text : String
        text =
            if model.sent then
                "Sent! Thank you"

            else
                model.field
    in
    [ TextArea.config
        FieldUpdated
        text
        |> TextArea.withPlaceholder "enter your comment here"
        |> TextArea.isDisabled model.sent
        |> TextArea.withFullHeight
        |> TextArea.toHtml
    ]



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
