module Page.Pricing
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, div, img, p, video)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Ports exposing (JsMsg(OpenPaintApp))
import Route exposing (Route(About))


-- TYPES --


type Msg
    = Noop



-- UPDATE --


update : Msg -> Cmd Msg
update msg =
    case msg of
        Noop ->
            Cmd.none



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace pricingNamespace
        |> stylesheet


pricingNamespace : String
pricingNamespace =
    Html.Custom.makeNamespace "Pricing"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace pricingNamespace


view : List (Html Msg)
view =
    []
