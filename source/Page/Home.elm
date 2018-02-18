module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Drawing exposing (Drawing)
import Data.User as User exposing (User)
import Html exposing (Html, a, div, img, p, text)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Variables exposing (leftSideWidth)
import Ports exposing (JsMsg(GetDrawings))
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = Noop


type alias Model =
    { drawings : List Drawing }



-- INIT --


init : User -> ( Model, Cmd Msg )
init user =
    { drawings = [] }
        & Ports.send GetDrawings



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    ( model
    , Cmd.none
    , NoReply
    )



-- STYLES --


type Class
    = Drawings
    | ProfilePictureContainer
    | ProfilePicture
    | Profile
    | BioContainer
    | Name
    | LeftSide


css : Stylesheet
css =
    [ (Css.class Drawings << List.append Html.Custom.indent)
        [ position absolute
        , top (px 8)
        , left (px (leftSideWidth + 16))
        , right (px 8)
        , bottom (px 12)
        , backgroundColor Ct.background2
        ]
    , (Css.class ProfilePictureContainer << List.append Html.Custom.indent)
        [ width (px (leftSideWidth - 4))
        , height (px (leftSideWidth - 4))
        , backgroundColor Ct.background2
        , overflow hidden
        , position absolute
        , left (px 0)
        , top (px 0)
        ]
    , Css.class ProfilePicture
        [ width (px (leftSideWidth - 4)) ]
    , Css.class Profile
        []
    , Css.class BioContainer
        [ left (px 0)
        , top (px 156)
        , position absolute
        ]
    , Css.class Name
        []
    , Css.class LeftSide
        [ position absolute
        , left (px 8)
        , top (px 8)
        , width (px leftSideWidth)
        , bottom (px 0)
        ]
    ]
        |> namespace homeNamespace
        |> stylesheet


homeNamespace : String
homeNamespace =
    Html.Custom.makeNamespace "Home"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace homeNamespace


type NotLoggedIn
    = Offline
    | LoggedOut
    | LoggingIn


view : User -> Model -> List (Html Msg)
view user model =
    [ leftSide user
    , drawings
    ]


leftSide : User -> Html Msg
leftSide user =
    div
        [ class [ LeftSide ] ]
        [ profile user ]


profile : User -> Html Msg
profile user =
    user
        |> profileChildren
        |> Html.Custom.container []


profileChildren : User -> List (Html Msg)
profileChildren user =
    [ profilePicture user.profilePic
    , bio user
    ]


bio : User -> Html Msg
bio user =
    div
        [ class [ BioContainer ] ]
        [ p
            [ class [ Name ] ]
            [ Html.text user.name ]
        ]


profilePicture : String -> Html Msg
profilePicture url =
    div
        [ class [ ProfilePictureContainer ] ]
        [ img
            [ class [ ProfilePicture ]
            , Attrs.src url
            ]
            []
        ]


drawings : Html Msg
drawings =
    div
        [ class [ Drawings ] ]
        []
