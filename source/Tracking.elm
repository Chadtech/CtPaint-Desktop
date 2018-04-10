module Tracking
    exposing
        ( Event(..)
        , Payload
        , encode
        )

import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Keyboard.Extra.Browser exposing (Browser)
import Util exposing (def)


-- TYPES --


type alias Payload =
    { event : Event
    , sessionId : Id
    , email : Maybe String
    }


type alias InitValues =
    { isMac : Bool
    , browser : Browser
    , buildNumber : Int
    }


{-| I would like to refactor this.
A list of all events, that require
namespaced constructrs ("PageX..") should
be broken out into each page module that does
tracking, which each page module responsible
for building the names and properties of its
own tracking events.
-}
type Event
    = AppInit InitValues
    | AppInitFail String
    | PageRoadMapWantClick String
    | PageContactSubmitClick String
    | PageErrorGoHomeClick
    | PageForgotPasswordSubmitClick
    | PageForgotPasswordSubmitEnterPress
    | PageForgotPasswordResponse (Maybe Error)
    | PageHomeDrawingClick
    | PageHomeNewDrawingClick
    | PageHomeCloseDrawingClick
    | PageHomeCloseNewDrawingClick
    | PageHomeOpenDrawingInCtPaintClick
    | PageHomeOpenDrawingLinkClick
    | PageHomeDeleteDrawingClick
    | PageHomeDeleteDrawingYesClick
    | PageHomeDeleteDrawingNoClick
    | PageHomeMakeADrawingClick
    | PageHomeRefreshClick
    | PageHomeBackToDrawingsClick
    | PageHomeTryAgainClick
    | PageLoginClick
    | PageLoginEnterPress
    | PageLoginFail Error
    | PageLoginForgotPasswordClick
    | PageLogoutFail Error
    | LoginSucceed
    | LogoutSucceed
    | PageOfflineRefreshClick
    | PagePricingDrawNowClick
    | PagePricingRegisterClick
    | PageRegisterSubmitEnterPress
    | PageRegisterSubmitClick
    | PageRegisterResponse (Maybe Error)
    | PageRegisterTosAgreeClick
    | PageRegisterReadTosClick
    | PageRegisterGoBackFromTosClick
    | PageRegisterEmailAgreeClick
    | PageResetPasswordGoHomeClick
    | PageResetPasswordSubmitEnterPress
    | PageResetPasswordSubmitClick
    | PageResetPasswordResponse (Maybe Error)
    | PageResetPasswordTryAgainClick
    | PageResetPasswordLoginClick
    | PageSettingsNavClick String
    | PageSettingsSubmitEnterPress
    | PageSettingsSaveClick Bool
    | PageSettingsSaveResponse (Maybe Error)
    | PageSplashLearnMoreClick
    | PageSplashDrawClick
    | PageVerifyResponse (Maybe Error)
    | PageVerifyLoginClick Bool
    | RouteChange String String
    | RouteChangeFail String
    | MsgDecodeFail String
    | PageMsgMismatch String String
    | DrawingDelete (Maybe Error)
    | NavClick String
    | DrawingsLoad Int


type alias Error =
    String



-- PUBLIC --


encode : Payload -> Value
encode payload =
    let
        ( name, eventProperties ) =
            encodeEvent payload.event
    in
    [ name
        |> String.split " "
        |> String.join "_"
        |> Encode.string
        |> def "name"
    , def "properties" <| encodeProperties payload eventProperties
    ]
        |> Encode.object


encodeProperties : Payload -> List ( String, Value ) -> Value
encodeProperties payload eventProperties =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| Encode.maybe Encode.string payload.email
    ]
        ++ eventProperties
        |> Encode.object


encodeEvent : Event -> ( String, List ( String, Value ) )
encodeEvent event =
    case event of
        AppInit initValues ->
            []
                |> def "app init"

        AppInitFail problem ->
            [ def "problem" <| Encode.string problem ]
                |> def "app fail init"

        PageRoadMapWantClick want ->
            [ def "want" <| Encode.string want ]
                |> def "page roadmap want click"

        PageContactSubmitClick comment ->
            [ def "comment" <| Encode.string comment ]
                |> def "page contact submit click"

        PageErrorGoHomeClick ->
            def "page error go-home click" []

        PageForgotPasswordSubmitClick ->
            def "page forgot-password submit click" []

        PageForgotPasswordSubmitEnterPress ->
            def "page forgot-password submit enter press" []

        PageForgotPasswordResponse maybeError ->
            [ maybeErrorField maybeError ]
                |> def "page forgot-password response "

        PageHomeDrawingClick ->
            def "page home drawing click" []

        PageHomeNewDrawingClick ->
            def "page home new-drawing click" []

        PageHomeCloseDrawingClick ->
            def "page home close-drawing click" []

        PageHomeCloseNewDrawingClick ->
            def "page home close-new-drawing click" []

        PageHomeOpenDrawingInCtPaintClick ->
            def "page home open-drawing-in-ctpaint click" []

        PageHomeOpenDrawingLinkClick ->
            def "page home open-drawing-link click" []

        PageHomeDeleteDrawingClick ->
            def "page home delete-drawing click" []

        PageHomeDeleteDrawingYesClick ->
            def "page home delete-drawing-yes click" []

        PageHomeDeleteDrawingNoClick ->
            def "page home delete-drawing-no click" []

        PageHomeMakeADrawingClick ->
            def "page home make-a-drawing click" []

        PageHomeRefreshClick ->
            def "page home refresh click" []

        PageHomeBackToDrawingsClick ->
            def "page home back-to-drawings click" []

        PageHomeTryAgainClick ->
            def "page home try-again click" []

        PageLoginClick ->
            def "page login click" []

        PageLoginEnterPress ->
            def "page login enter press" []

        PageLoginFail error ->
            [ errorField error ]
                |> def "page login response"

        PageLoginForgotPasswordClick ->
            def "page login forgot-password click" []

        PageLogoutFail error ->
            [ errorField error ]
                |> def "page logout response"

        LoginSucceed ->
            def "login succeed" []

        LogoutSucceed ->
            def "logout succeed" []

        PageOfflineRefreshClick ->
            def "page offline refresh click" []

        PagePricingDrawNowClick ->
            def "page pricing draw-now click" []

        PagePricingRegisterClick ->
            def "page pricing register click" []

        PageRegisterSubmitEnterPress ->
            def "page register submit enter press" []

        PageRegisterSubmitClick ->
            def "page register submit click" []

        PageRegisterResponse maybeError ->
            [ maybeErrorField maybeError ]
                |> def "page register response"

        PageRegisterTosAgreeClick ->
            def "page register tos-agree click" []

        PageRegisterReadTosClick ->
            def "page register read-tos click" []

        PageRegisterGoBackFromTosClick ->
            def "page register go-back-from-tos click" []

        PageRegisterEmailAgreeClick ->
            def "page register email-agree click" []

        PageResetPasswordGoHomeClick ->
            def "page reset-password go-home click" []

        PageResetPasswordSubmitEnterPress ->
            def "page reset-password submit enter press" []

        PageResetPasswordSubmitClick ->
            def "page reset-password submit click" []

        PageResetPasswordResponse maybeError ->
            [ maybeErrorField maybeError ]
                |> def "page reset-password response"

        PageResetPasswordTryAgainClick ->
            def "page reset-password try-again click" []

        PageResetPasswordLoginClick ->
            def "page reset-password login click" []

        PageSettingsSaveClick isDisabled ->
            [ disabledField isDisabled ]
                |> def "page settings save click"

        PageSettingsSubmitEnterPress ->
            def "page settings submit enter press" []

        PageSettingsNavClick page ->
            [ def "nav-page" <| Encode.string page ]
                |> def "page settings nav click"

        PageSettingsSaveResponse maybeError ->
            [ maybeErrorField maybeError ]
                |> def "page settings save response"

        PageSplashDrawClick ->
            def "page splash draw click" []

        PageSplashLearnMoreClick ->
            def "page splash learn-more click" []

        PageVerifyResponse maybeError ->
            [ maybeErrorField maybeError ]
                |> def "page verify response"

        PageVerifyLoginClick isDisabled ->
            [ disabledField isDisabled ]
                |> def "page verify login click"

        RouteChange to from ->
            [ def "from" <| Encode.string from
            , def "to" <| Encode.string to
            ]
                |> def "route change"

        RouteChangeFail url ->
            [ def "url" <| Encode.string url ]
                |> def "route change fail"

        MsgDecodeFail err ->
            [ errorField err ]
                |> def "msg decode fail"

        PageMsgMismatch msgType page ->
            [ def "msg-type" <| Encode.string msgType
            , def "page" <| Encode.string page
            ]
                |> def "page msg mismatch"

        DrawingDelete maybeError ->
            [ maybeErrorField maybeError ]
                |> def "drawing delete"

        NavClick route ->
            [ def "route" <| Encode.string route ]
                |> def "nav click"

        DrawingsLoad n ->
            [ def "number-loaded" <| Encode.int n ]
                |> def "drawings load"


disabledField : Bool -> ( String, Value )
disabledField =
    def "disabled" << Encode.bool


errorField : String -> ( String, Value )
errorField =
    def "error" << Encode.string


maybeErrorField : Maybe String -> ( String, Value )
maybeErrorField maybeError =
    def "error" <| Encode.maybe Encode.string maybeError
