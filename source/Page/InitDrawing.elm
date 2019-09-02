module Page.InitDrawing exposing
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
import Html.Styled exposing (Html)
import Session exposing (Session)
import Ui.InitDrawing as InitDrawing
import Util.Html as HtmlUtil
import View.CardHeader as CardHeader
import View.SingleCardPage as SingleCardPage



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , user : User
    , initDrawing : InitDrawing.Model
    }


type Msg
    = InitDrawingMsg InitDrawing.Msg



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


init : Session -> User -> Model
init session user =
    { session = session
    , user = user
    , initDrawing = InitDrawing.init
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setInitDrawing : InitDrawing.Model -> Model -> Model
setInitDrawing subModel model =
    { model | initDrawing = subModel }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        header : Html Msg
        header =
            InitDrawing.header
                |> CardHeader.toHtml

        body : List (Html Msg)
        body =
            InitDrawing.bodyView model.initDrawing
                |> HtmlUtil.mapList InitDrawingMsg
    in
    { title = Nothing
    , body =
        SingleCardPage.view
            (InitDrawing.view (header :: body))
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitDrawingMsg subMsg ->
            let
                ( newInitDrawingModel, cmd ) =
                    InitDrawing.update
                        (Session.getNavKey <| getSession model)
                        subMsg
                        model.initDrawing
            in
            ( setInitDrawing newInitDrawingModel model
            , Cmd.map InitDrawingMsg cmd
            )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        InitDrawingMsg subMsg ->
            InitDrawing.track subMsg
