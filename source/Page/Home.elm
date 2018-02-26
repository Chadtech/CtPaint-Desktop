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
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Drawing exposing (Drawing)
import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Html exposing (Html, a, div, img, p, text)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Variables exposing (leftSideWidth)
import Id
import Ports exposing (JsMsg(GetDrawings))
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = Noop


type alias Model =
    ()



-- INIT --


init : User -> ( Model, Cmd Msg )
init user =
    ()
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
    | DrawingContainer
    | DrawingImageContainer
    | DrawingTitle
    | Drawing
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
    , Css.class DrawingContainer
        [ width (px 200)
        , height (px 200)
        , border3 (px 2) solid Ct.point0
        , overflow hidden
        , marginTop (px 8)
        , marginLeft (px 8)
        , display inlineBlock
        , position relative
        , cursor pointer
        , hover
            [ border3 (px 2) solid Ct.point1
            , children
                [ Css.class DrawingTitle
                    [ backgroundColor Ct.background3
                    , children
                        [ Css.Elements.p
                            [ color Ct.point1 ]
                        ]
                    ]
                ]
            ]
        ]
    , Css.class DrawingTitle
        [ position absolute
        , width (pct 100)
        , left (px 0)
        , bottom (px 0)
        , backgroundColor Ct.background1
        , padding (px 4)
        , textAlign center
        ]
    , Css.class Drawing
        [ width (px 220)
        , marginLeft (px -10)
        , marginTop (px -10)
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


view : Taco -> User -> Model -> List (Html Msg)
view taco user model =
    [ leftSide user
    , drawings (Id.values taco.entities.drawings)
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


drawings : List Drawing -> Html Msg
drawings drawings =
    div
        [ class [ Drawings ] ]
        (List.map drawing drawings |> List.repeat 40 |> List.concat)


drawing : Drawing -> Html Msg
drawing drawing =
    div
        [ class [ DrawingContainer ] ]
        [ img
            [ class [ Drawing ]
            , Attrs.src drawing.data
            ]
            []
        , div
            [ class [ DrawingTitle ] ]
            [ p [] [ Html.text drawing.name ] ]
        ]
