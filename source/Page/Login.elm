module Page.Login exposing
    ( Model
    , Msg
    , getSession
    , init
    , track
    , update
    , view
    )

import Css
import Data.Document exposing (Document)
import Data.NavKey exposing (NavKey)
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Session exposing (Session)
import Style
import Ui.LoginCard as LoginCard
import Util.Html as HtmlUtil
import View.CardHeader as CardHeader exposing (CardHeader)



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , loginCard : LoginCard.Model
    }


type Msg
    = LoginCardMsg LoginCard.Msg



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Model
init session =
    { session = session
    , loginCard = LoginCard.init
    }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setLoginCard : LoginCard.Model -> Model -> Model
setLoginCard newLoginCard model =
    { model | loginCard = newLoginCard }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        header : Html Msg
        header =
            LoginCard.header
                |> CardHeader.toHtml

        body : List (Html Msg)
        body =
            LoginCard.viewBody
                model.loginCard
                |> HtmlUtil.mapList LoginCardMsg
    in
    { title = Just "login"
    , body =
        [ Grid.row
            [ Css.flex (Css.int 1)
            , Style.centerContent
            ]
            [ Grid.column
                [ Grid.columnShrink
                , Style.centerContent
                , Css.flexDirection Css.column
                ]
                [ LoginCard.view
                    (header :: body)
                ]
            ]
        ]
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : NavKey -> Msg -> Model -> ( Model, Cmd Msg )
update navKey msg model =
    case msg of
        LoginCardMsg subMsg ->
            let
                ( newLoginCardModel, cmd ) =
                    LoginCard.update
                        navKey
                        subMsg
                        model.loginCard
            in
            ( setLoginCard newLoginCardModel model
            , Cmd.map LoginCardMsg cmd
            )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        LoginCardMsg subMsg ->
            LoginCard.track subMsg
