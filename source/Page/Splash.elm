module Page.Splash
    exposing
        ( Msg
        , css
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, img)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom


-- TYPES --


type Msg
    = Noop



-- UPDATE --


update : Msg -> Cmd Msg
update Noop =
    Cmd.none



-- STYLES --


type Class
    = Logo


css : Stylesheet
css =
    [ Css.class Logo
        [ margin auto
        , display block
        ]
    ]
        |> namespace splashNamespace
        |> stylesheet


splashNamespace : String
splashNamespace =
    Html.Custom.makeNamespace "Splash"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace splashNamespace


view : Taco -> List (Html Msg)
view taco =
    [ img
        [ class [ Logo ]
        , Attrs.src (taco.config.mountPath ++ "/splash-image.png")
        ]
        []
    ]
