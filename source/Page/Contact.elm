module Page.Contact
    exposing
        ( css
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, br, div, p)
import Html.CssHelpers
import Html.Custom


-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace contactNamespace
        |> stylesheet


contactNamespace : String
contactNamespace =
    Html.Custom.makeNamespace "Contact"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace contactNamespace


view : Html msg
view =
    [ Html.Custom.header
        { text = "contact"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody [] body
    ]
        |> Html.Custom.cardSolitary []
        |> List.singleton
        |> Html.Custom.background []


body : List (Html msg)
body =
    [ comment0
    , email
    , comment1
    ]
        |> List.map p_
        |> List.intersperse (br [] [])


comment0 : String
comment0 =
    """
    Send your  questions, comments, criticisms, and bug reports
    to..
    """


email : String
email =
    """
    ctpaint@programhouse.us
    """


comment1 : String
comment1 =
    """
    I would love to hear from you!
    """


p_ : String -> Html msg
p_ str =
    p
        []
        [ Html.text str ]
