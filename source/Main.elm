module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation
import Data.BuildNumber as BuildNumber
import Data.Document as Document exposing (Document)
import Data.Listener as Listener exposing (Listener)
import Data.NavKey as NavKey
import Data.SessionId as SessionId
import Data.Size exposing (Size)
import Data.Tracking as Tracking
import Data.User as Viewer exposing (User)
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Model exposing (Model)
import Page.About as About
import Page.Contact as Contact
import Page.Drawings as Drawings
import Page.Login as Login
import Page.Logout as Logout
import Page.PageNotFound as PageNotFound
import Page.PaintApp as PaintApp
import Page.ResetPassword as ResetPassword
import Page.Settings as Settings
import Page.Splash as Splash
import Ports
import Route exposing (Route)
import Session exposing (Session)
import Style
import Ui.Nav as Nav
import Url exposing (Url)
import Util.Cmd as CmdUtil
import Util.Html as HtmlUtil
import View.Card as Card
import View.CardHeader as CardHeader
import View.SingleCardPage as SingleCardPage



-------------------------------------------------------------------------------
-- MAIN --
-------------------------------------------------------------------------------


main : Program Decode.Value (Result Decode.Error Model) Msg
main =
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view =
        view
            >> Document.cons Style.globals
            >> Document.toBrowserDocument
    , onUrlChange = onNavigation
    , onUrlRequest = UrlRequested
    }
        |> Browser.application


onNavigation : Url -> Msg
onNavigation =
    Route.fromUrl >> UrlChanged


type Msg
    = NavMsg Nav.Msg
      -- Browser Things
    | UrlChanged (Result String Route)
    | UrlRequested UrlRequest
    | WindowResized Size
      -- JS Message Decoding
    | ListenerNotFound String
    | FailedToDecodeJsMsg
    | JsMsg Decode.Value
      -- Pages
    | PageNotFoundMsg PageNotFound.Msg
    | SplashMsg Splash.Msg
    | LoginMsg Login.Msg
    | ResetPasswordMsg ResetPassword.Msg
    | HomeMsg Drawings.Msg
    | SettingsMsg Settings.Msg
    | ContactMsg Contact.Msg



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init :
    Decode.Value
    -> Url
    -> Browser.Navigation.Key
    -> ( Result Decode.Error Model, Cmd Msg )
init json url key =
    case
        Decode.decodeValue
            (Model.decoder <| NavKey.fromNativeKey key)
            json
    of
        Ok model ->
            update
                (onNavigation url)
                (Ok model)

        Err decodeError ->
            ( Err decodeError
            , Tracking.event "init failed"
                |> Tracking.withString
                    "error"
                    (Decode.errorToString decodeError)
                |> Tracking.send
            )



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Result Decode.Error Model -> Document Msg
view result =
    case result of
        Ok page ->
            viewPage page

        Err error ->
            viewError error


viewError : Decode.Error -> Document msg
viewError decodeError =
    let
        header : Html msg
        header =
            CardHeader.config
                { title = "error" }
                |> CardHeader.toHtml

        errorBody : List (Html msg)
        errorBody =
            [ Card.textRow
                []
                """
                Something went really wrong. Sorry.
                Please report this error if you can.
                You can copy and paste the error below,
                and send it to my email at
                chadtech0@gmail.com
                """
            , Card.errorDisplay
                (Decode.errorToString decodeError)
            ]
    in
    { title = Nothing
    , body =
        Card.view
            [ Style.width 10 ]
            (header :: errorBody)
            |> SingleCardPage.view
    }


viewPage : Model -> Document Msg
viewPage model =
    let
        viewInFrame : (msg -> Msg) -> Document msg -> Document Msg
        viewInFrame msgCtor { title, body } =
            { title = title
            , body =
                Html.map NavMsg (Nav.view model)
                    :: HtmlUtil.mapList msgCtor body
            }
    in
    case model of
        Model.Blank _ ->
            { title = Nothing
            , body = []
            }

        Model.PageNotFound _ ->
            PageNotFound.view
                |> Document.map PageNotFoundMsg

        Model.PaintApp subModel ->
            PaintApp.view subModel

        Model.Splash session ->
            session
                |> Session.getMountPath
                |> Splash.view
                |> viewInFrame SplashMsg

        Model.About { session } ->
            About.view
                (Session.getBuildNumber session)
                (Session.getMountPath session)
                |> viewInFrame identity

        Model.Login subModel ->
            Login.view subModel
                |> Document.map LoginMsg

        Model.ResetPassword subModel ->
            ResetPassword.view subModel
                |> Document.map ResetPasswordMsg

        Model.Settings subModel ->
            Settings.view subModel
                |> viewInFrame SettingsMsg

        Model.Drawings subModel ->
            Drawings.view subModel
                |> viewInFrame HomeMsg

        Model.Logout subModel ->
            Logout.view subModel

        Model.Contact subModel ->
            Contact.view subModel
                |> viewInFrame ContactMsg



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Result Decode.Error Model -> ( Result Decode.Error Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            updateFromOk msg model
                |> Tuple.mapFirst Ok
                |> CmdUtil.addCmd (track msg model)

        Err err ->
            ( Err err, Cmd.none )


updateFromOk : Msg -> Model -> ( Model, Cmd Msg )
updateFromOk msg model =
    let
        session : Session
        session =
            Model.getSession model

        user : User
        user =
            Model.getUser model
    in
    case msg of
        UrlChanged routeResult ->
            handleRoute session user routeResult

        UrlRequested _ ->
            model
                |> CmdUtil.withNoCmd

        NavMsg navMsg ->
            ( model
            , Nav.update
                (Session.getNavKey session)
                navMsg
                |> Cmd.map NavMsg
            )

        SplashMsg subMsg ->
            case model of
                Model.Splash _ ->
                    ( model
                    , Splash.update
                        (Session.getNavKey session)
                        subMsg
                        |> Cmd.map SplashMsg
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        LoginMsg subMsg ->
            case model of
                Model.Login subModel ->
                    Login.update subMsg subModel
                        |> CmdUtil.mapModel Model.Login
                        |> CmdUtil.mapCmd LoginMsg

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ResetPasswordMsg subMsg ->
            case model of
                Model.ResetPassword subModel ->
                    ResetPassword.update
                        subMsg
                        subModel
                        |> CmdUtil.mapModel Model.ResetPassword
                        |> CmdUtil.mapCmd ResetPasswordMsg

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        PageNotFoundMsg subMsg ->
            case model of
                Model.PageNotFound _ ->
                    ( model
                    , PageNotFound.update
                        (Session.getNavKey session)
                        subMsg
                        |> Cmd.map PageNotFoundMsg
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ListenerNotFound _ ->
            model
                |> CmdUtil.withNoCmd

        FailedToDecodeJsMsg ->
            model
                |> CmdUtil.withNoCmd

        HomeMsg subMsg ->
            case model of
                Model.Drawings subModel ->
                    Drawings.update subMsg subModel
                        |> Tuple.mapFirst Model.Drawings
                        |> CmdUtil.mapCmd HomeMsg

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        SettingsMsg subMsg ->
            case model of
                Model.Settings subModel ->
                    Settings.update subMsg subModel
                        |> Tuple.mapFirst Model.Settings
                        |> CmdUtil.mapCmd SettingsMsg

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        ContactMsg subMsg ->
            case model of
                Model.Contact subModel ->
                    Contact.update subMsg subModel
                        |> Tuple.mapFirst Model.Contact

                _ ->
                    model
                        |> CmdUtil.withNoCmd

        WindowResized size ->
            model
                |> Model.mapSession (Session.setWindowSize size)
                |> CmdUtil.withNoCmd

        JsMsg json ->
            updateFromOk (decodeMsg model json) model


handleRoute : Session -> User -> Result String Route -> ( Model, Cmd Msg )
handleRoute session user routeResult =
    case routeResult of
        Ok route ->
            handleRouteFromOk session user route

        Err _ ->
            Model.PageNotFound
                { session = session
                , user = user
                }
                |> CmdUtil.withNoCmd


handleRouteFromOk : Session -> User -> Route -> ( Model, Cmd Msg )
handleRouteFromOk session user route =
    case route of
        Route.PaintApp subRoute ->
            Model.PaintApp
                (PaintApp.init session user)
                |> CmdUtil.withNoCmd

        Route.Landing ->
            case user of
                Viewer.User ->
                    Model.Splash session
                        |> CmdUtil.withNoCmd

                Viewer.Account account ->
                    Drawings.init session account
                        |> Tuple.mapFirst Model.Drawings
                        |> CmdUtil.mapCmd HomeMsg

        Route.About ->
            Model.About
                { session = session
                , user = user
                }
                |> CmdUtil.withNoCmd

        Route.Login ->
            Login.init session
                |> Tuple.mapFirst Model.Login

        Route.ResetPassword ->
            ResetPassword.init session
                |> Tuple.mapFirst Model.ResetPassword

        Route.Logout ->
            Logout.init session
                |> Tuple.mapFirst Model.Logout

        Route.Settings ->
            case user of
                Viewer.User ->
                    Model.PageNotFound
                        { session = session
                        , user = user
                        }
                        |> CmdUtil.withNoCmd

                Viewer.Account account ->
                    Settings.init session account
                        |> Model.Settings
                        |> CmdUtil.withNoCmd

        Route.Contact ->
            Model.Contact
                (Contact.init session user)
                |> CmdUtil.withNoCmd


track : Msg -> Model -> Cmd Msg
track msg model =
    let
        session : Session
        session =
            Model.getSession model
    in
    msg
        |> trackPage
        |> Tracking.withString "page" (Model.pageId model)
        |> Tracking.withProp
            "sessionId"
            (SessionId.encode <| Session.getSessionId session)
        |> Tracking.withString
            "buildNumber"
            (BuildNumber.toString <| Session.getBuildNumber session)
        |> Tracking.send


trackPage : Msg -> Maybe Tracking.Event
trackPage msg =
    case msg of
        UrlChanged _ ->
            Nothing

        UrlRequested _ ->
            Nothing

        ListenerNotFound listener ->
            Tracking.event "listener not found"
                |> Tracking.withString "listener" listener

        FailedToDecodeJsMsg ->
            Tracking.event "failed to decode js msg"

        NavMsg subMsg ->
            Nav.track subMsg

        SplashMsg subMsg ->
            Splash.track subMsg

        LoginMsg subMsg ->
            Login.track subMsg

        ResetPasswordMsg subMsg ->
            ResetPassword.track subMsg

        PageNotFoundMsg subMsg ->
            PageNotFound.track subMsg

        HomeMsg subMsg ->
            Drawings.track subMsg

        SettingsMsg subMsg ->
            Settings.track subMsg

        ContactMsg subMsg ->
            Contact.track subMsg

        WindowResized _ ->
            Nothing

        JsMsg _ ->
            Nothing



-------------------------------------------------------------------------------
-- SUBSCRIPTIONS --
-------------------------------------------------------------------------------


subscriptions : Result Decode.Error Model -> Sub Msg
subscriptions result =
    result
        |> Result.map subscriptionsFromOk
        |> Result.withDefault Sub.none


subscriptionsFromOk : Model -> Sub Msg
subscriptionsFromOk model =
    --    Ports.fromJs (decodeMsg model)
    Ports.fromJs JsMsg


decodeMsg : Model -> Decode.Value -> Msg
decodeMsg model json =
    let
        incomingMsgDecoder : Decoder ( String, Decode.Value )
        incomingMsgDecoder =
            Decode.map2 Tuple.pair
                (Decode.field "name" Decode.string)
                (Decode.field "props" Decode.value)
    in
    case Decode.decodeValue incomingMsgDecoder json of
        Ok ( name, props ) ->
            let
                checkListeners : List (Listener Msg) -> Msg
                checkListeners remainingListeners =
                    case remainingListeners of
                        [] ->
                            ListenerNotFound name

                        first :: rest ->
                            if Listener.getName first == name then
                                Listener.handle first props

                            else
                                checkListeners rest
            in
            checkListeners
                (listeners model)

        Err _ ->
            FailedToDecodeJsMsg


listeners : Model -> List (Listener Msg)
listeners model =
    case model of
        Model.Login _ ->
            Listener.mapMany LoginMsg Login.listeners

        Model.ResetPassword _ ->
            [ ResetPassword.listener
                |> Listener.map ResetPasswordMsg
            ]

        Model.Drawings _ ->
            Listener.mapMany HomeMsg Drawings.listeners

        _ ->
            []
