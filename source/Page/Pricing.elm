module Page.Pricing
    exposing
        ( Msg
        , css
        , track
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Data.User as User
import Html exposing (Attribute, Html, a, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Ports exposing (JsMsg(OpenPaintApp))
import Route exposing (Route(Register))


-- TYPES --


type Msg
    = DrawNowClicked
    | RegisterClicked



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        DrawNowClicked ->
            Ports.send OpenPaintApp

        RegisterClicked ->
            Route.goTo Register



-- TRACKING --


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        DrawNowClicked ->
            Tracking.noProps "draw-now click"

        RegisterClicked ->
            Tracking.noProps "register click"



-- STYLES --


type Class
    = SubscriptionsContainer
    | Subscription
    | FeatureList
    | Feature
    | Odd
    | Name
    | Price
    | Disabled
    | Header


subscriptionWidth : Float
subscriptionWidth =
    326


css : Stylesheet
css =
    [ Css.class SubscriptionsContainer
        [ width (px 1000)
        , displayFlex
        , justifyContent spaceBetween
        , margin auto
        ]
    , Css.class Subscription
        [ height (px 400)
        , flex (int 1)
        , children
            [ Css.Elements.a
                [ width (px (subscriptionWidth - 20))
                , textAlign center
                ]
            ]
        ]
    , (Css.class FeatureList << List.append Html.Custom.indent)
        [ width (px (subscriptionWidth - 4))
        , height (px 300)
        , overflow scroll
        , backgroundColor Ct.background2
        , marginBottom (px 8)
        ]
    , Css.class Feature
        [ padding2 (px 4) (px 8) ]
    , Css.class Name
        [ marginBottom (px 8) ]
    , Css.class Price
        [ marginBottom (px 8) ]
    , Css.class Disabled
        [ backgroundColor Ct.ignorable1
        , active Html.Custom.outdent
        , cursor default
        ]
    , Css.class Odd
        [ backgroundColor Ct.background3 ]
    , Css.class Header
        [ margin auto
        , marginBottom (px 8)
        , textAlign center
        , display block
        , width (px 800)
        ]
    ]
        |> namespace pricingNamespace
        |> stylesheet


pricingNamespace : String
pricingNamespace =
    Html.Custom.makeNamespace "Pricing"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace pricingNamespace


view : Taco -> List (Html Msg)
view taco =
    [ p
        [ class [ Header ] ]
        [ Html.text "subscription tiers" ]
    , subscriptions taco
    ]


subscriptions : Taco -> Html Msg
subscriptions taco =
    [ subscription
        { name = "no account"
        , price = "free"
        , buttonLabel = "draw now"
        , buttonMsg = Just DrawNowClicked
        , features =
            [ "CtPaint"
            , "4 days of access per month"
            ]
        }
    , subscription
        { name = "account"
        , price = "free"
        , buttonLabel = "register"
        , buttonMsg =
            case taco.user of
                User.Offline ->
                    Nothing

                _ ->
                    Just RegisterClicked
        , features =
            [ "CtPaint"
            , "unlimited access"
            , "limited cloud storage"
            , "public image upload"
            ]
        }
    , subscription
        { name = "bronze"
        , price = "$3.50 per month"
        , buttonLabel = "coming soon"
        , buttonMsg = Nothing
        , features =
            [ "CtPaint"
            , "unlimited access"
            , "unlimited cloud storage"
            , "public image upload"
            , "private storage"
            ]
        }
    ]
        |> div [ class [ SubscriptionsContainer ] ]


type alias SubscriptionPayload =
    { name : String
    , price : String
    , buttonLabel : String
    , buttonMsg : Maybe Msg
    , features : List String
    }


subscription : SubscriptionPayload -> Html Msg
subscription { name, price, buttonLabel, buttonMsg, features } =
    div
        [ class [ Subscription ] ]
        [ p
            [ class [ Name ] ]
            [ Html.text name ]
        , div
            [ class [ FeatureList ] ]
            (List.indexedMap feature features)
        , p
            [ class [ Price ] ]
            [ Html.text price ]
        , button buttonLabel buttonMsg
        ]


feature : Int -> String -> Html Msg
feature index str =
    p
        [ classList
            [ ( Feature, True )
            , ( Odd, index % 2 == 1 )
            ]
        ]
        [ Html.text str ]


button : String -> Maybe Msg -> Html Msg
button label maybeMsg =
    a
        (buttonAttrs maybeMsg)
        [ Html.text label ]


buttonAttrs : Maybe Msg -> List (Attribute Msg)
buttonAttrs maybeMsg =
    case maybeMsg of
        Just msg ->
            [ onClick msg ]

        Nothing ->
            [ class [ Disabled ] ]
