module View exposing (view)

import Html exposing (Attribute, Html, br, div, input, p, text)
import Html.Attributes exposing (placeholder, spellcheck, value)
import Html.CssHelpers
import Html.Events exposing (onInput)
import Styles
import Styles.Shared exposing (Classes(..), appNameSpace)
import Types exposing (Model, Msg(..))
import Util exposing (onEnter)


{ id, class, classList } =
    Html.CssHelpers.withNamespace appNameSpace



-- VIEW --


view : Model -> Html Msg
view model =
    div
        [ class [ Card ] ]
        [ header
        , div
            [ class [ CardBody ] ]
            msg
        ]


header : Html Msg
header =
    div
        [ class [ Header ] ]
        [ text "Thank you" ]


msg : List Html Msg
msg =
    []



-- COMPONENTS --


title : Html Msg
title =
    p
        [ class [ Point, Big ] ]
        [ text "Elm Project : Go!" ]


inputField : String -> Html Msg
inputField str =
    input
        [ class [ Field ]
        , value str
        , onInput UpdateField
        , placeholder "Press enter to console log msg"
        , spellcheck False
        , onEnter EnterHappened
        ]
        []
