module Main exposing (main)

import Browser exposing (UrlRequest)
import Browser.Navigation
import Data.Document as Document exposing (Document)
import Data.NavKey as NavKey
import Data.Tracking as Tracking
import Html.Styled as Html exposing (Html)
import Json.Decode as Decode
import Model exposing (Model(..))
import Page.Splash as Splash
import Route exposing (Route)
import Session exposing (Session)
import Style
import Ui.Nav as Nav
import Url exposing (Url)
import Util.Cmd as CmdUtil



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
    = UrlChanged (Result String Route)
    | UrlRequested UrlRequest
    | NavMsg Nav.Msg
    | SplashMsg Splash.Msg



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
            (Session.decoder <| NavKey.fromNativeKey key)
            json
    of
        Ok session ->
            update
                (onNavigation url)
                (Ok <| Blank session)

        Err decodeError ->
            Err decodeError
                |> CmdUtil.withNoCmd



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Result Decode.Error Model -> Document Msg
view result =
    case result of
        Ok page ->
            viewPage page

        Err error ->
            { title = Nothing
            , body = [ Html.text <| Decode.errorToString error ]
            }


viewPage : Model -> Document Msg
viewPage model =
    case model of
        Blank _ ->
            { title = Nothing
            , body = []
            }

        Splash session ->
            session
                |> Session.getMountPath
                |> Splash.view
                |> Document.map SplashMsg
                |> viewInFrame model


viewInFrame : Model -> Document Msg -> Document Msg
viewInFrame model { title, body } =
    { title = title
    , body =
        Html.map NavMsg (Nav.view model) :: body
    }



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Result Decode.Error Model -> ( Result Decode.Error Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            updateFromOk msg model
                |> Tuple.mapFirst Ok

        Err err ->
            ( Err err, Cmd.none )


updateFromOk : Msg -> Model -> ( Model, Cmd Msg )
updateFromOk msg model =
    let
        session : Session
        session =
            Model.getSession model
    in
    case msg of
        UrlChanged routeResult ->
            handleRoute routeResult model

        UrlRequested _ ->
            model
                |> CmdUtil.withNoCmd

        NavMsg navMsg ->
            ( model
            , Cmd.map NavMsg (Nav.update navMsg)
            )

        SplashMsg subMsg ->
            case model of
                Splash _ ->
                    ( model
                    , Splash.update
                        (Session.getNavKey session)
                        subMsg
                        |> Cmd.map SplashMsg
                    )

                _ ->
                    model
                        |> CmdUtil.withNoCmd


handleRoute : Result String Route -> Model -> ( Model, Cmd Msg )
handleRoute routeResult model =
    case routeResult of
        Ok route ->
            handleRouteFromOk route model

        Err isntValidUrl ->
            model
                |> CmdUtil.withNoCmd


handleRouteFromOk : Route -> Model -> ( Model, Cmd Msg )
handleRouteFromOk route model =
    let
        session : Session
        session =
            Model.getSession model
    in
    case route of
        Route.Landing ->
            Splash session
                |> CmdUtil.withNoCmd

        _ ->
            model
                |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        UrlChanged _ ->
            Nothing

        UrlRequested _ ->
            Nothing

        NavMsg subMsg ->
            Nav.track subMsg

        SplashMsg subMsg ->
            Splash.track subMsg



-------------------------------------------------------------------------------
-- SUBSCRIPTIONS --
-------------------------------------------------------------------------------


subscriptions : Result Decode.Error Model -> Sub Msg
subscriptions =
    Result.map subscriptionsFromOk
        >> Result.withDefault Sub.none


subscriptionsFromOk : Model -> Sub Msg
subscriptionsFromOk model =
    Sub.none



--    case Decode.decodeValue Flags.decoder json of
--        Ok flags ->
--            let
--                taco : Taco
--                taco =
--                    Taco.fromFlags flags
--
--                initTrack : Cmd Msg
--                initTrack =
--                    [ Tuple.pair "is-mac" <| Encode.bool flags.isMac
--                    , Tuple.pair "browser" <| Browser.encode flags.browser
--                    , Tuple.pair "build-number" <| Encode.int flags.buildNumber
--                    ]
--                        |> Tuple.pair "app init"
--                        |> Just
--                        |> Ports.sendTracking taco
--            in
--            { page = Blank
--            , taco = taco
--            }
--                |> Update.update (onNavigation location)
--                |> Tuple.mapFirst Ok
--                |> CmdUtil.addCmd initTrack
--
--        Err err ->
--            ( Err err
--            , { sessionId = SessionId.error
--              , email = Nothing
--              , name = "desktop app init fail"
--              , properties =
--                    err
--                        |> Encode.string
--                        |> Tuple.pair "error"
--                        |> List.singleton
--              }
--                |> Ports.Track
--                |> Ports.send
--            )
