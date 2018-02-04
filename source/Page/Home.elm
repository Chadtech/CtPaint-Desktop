module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Drawing exposing (Drawing)
import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Html exposing (Html, a, div, img, p, text)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Ports exposing (JsMsg(GetDrawings))
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = OpenCtPaintClicked


type alias Model =
    { ctPaintMenuOpen : Bool
    , drawings : List Drawing
    }



-- INIT --


init : User -> ( Model, Cmd Msg )
init user =
    { ctPaintMenuOpen = False
    , drawings = []
    }
        & Ports.send GetDrawings



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        OpenCtPaintClicked ->
            ( openCtPaintMenu model
            , Cmd.none
            , NoReply
            )


openCtPaintMenu : Model -> Model
openCtPaintMenu model =
    { model | ctPaintMenuOpen = True }



-- STYLES --


type Class
    = Container
    | Drawings
    | ProfilePictureContainer
    | ProfilePicture
    | Profile
    | BioContainer
    | Name


leftSideWidth : Float
leftSideWidth =
    158


css : Stylesheet
css =
    [ Css.class Container
        [ position relative
        , marginLeft (px 2)
        , marginBottom (px 2)
        , width (px (leftSideWidth - 4))
        , children
            [ Css.Elements.a
                [ width (px (leftSideWidth - 24))
                , textAlign center
                ]
            ]
        ]
    , (Css.class Drawings << List.append Html.Custom.indent)
        [ position absolute
        , top (px 0)
        , left (px leftSideWidth)
        , right (px 2)
        , bottom (px 6)
        , backgroundColor backgroundx2
        ]
    , (Css.class ProfilePictureContainer << List.append Html.Custom.indent)
        [ width (px (leftSideWidth - 8))
        , height (px (leftSideWidth - 8))
        , backgroundColor backgroundx2
        , overflow hidden
        , position absolute
        , left (px 0)
        , top (px 0)
        ]
    , Css.class ProfilePicture
        [ width (px (leftSideWidth - 8)) ]
    , Css.class Profile
        []
    , Css.class BioContainer
        [ left (px 0)
        , top (px 156)
        , position absolute
        ]
    , Css.class Name
        []
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


view : Taco -> Model -> List (Html Msg)
view taco model =
    case taco.user of
        User.LoggedIn user ->
            loggedInView user

        User.Offline ->
            loggedOutView Offline

        User.LoggedOut ->
            loggedOutView LoggedOut

        User.LoggingIn ->
            loggedOutView LoggingIn


loggedInView : User -> List (Html Msg)
loggedInView user =
    [ openCtPaintButton
    , profile user
    , drawings
    ]


openCtPaintButton : Html Msg
openCtPaintButton =
    div
        [ class [ Container ] ]
        [ a
            [ onClick OpenCtPaintClicked ]
            [ Html.text "open ctpaint" ]
        ]


profile : User -> Html Msg
profile user =
    div
        [ class [ Container ] ]
        (profileChildren user)


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



-- LOGGED OUT VIEW --


loggedOutView : NotLoggedIn -> List (Html Msg)
loggedOutView notLoggedin =
    []
