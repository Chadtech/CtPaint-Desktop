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
import Data.Taco as Taco exposing (Taco)
import Data.User as User exposing (User)
import Html exposing (Html, a, div, img, p, text)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Html.Variables exposing (leftSideWidth)
import Id exposing (Id)
import Ports exposing (JsMsg(GetDrawings))
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = DrawingClicked Id
    | NewDrawingClicked


type alias Model =
    { focusedDrawing : Maybe Id }



-- INIT --


init : User -> ( Model, Cmd Msg )
init user =
    { focusedDrawing = Nothing }
        & Ports.send GetDrawings



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        DrawingClicked id ->
            { model | focusedDrawing = Just id }
                |> Reply.nothing

        NewDrawingClicked ->
            model
                |> Reply.nothing



-- STYLES --


type Class
    = Drawings
    | DrawingContainer
    | DrawingImageContainer
    | FocusedDrawingContainer
    | FocusedDrawing
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
        [ marginTop (px 8)
        , marginLeft (px 8)
        , display inlineBlock
        , position relative
        ]
    , (Css.class DrawingImageContainer << List.append Html.Custom.indent)
        [ overflow hidden
        , width (px 200)
        , height (px 200)
        ]
    , Css.class FocusedDrawingContainer
        [ top (px 8)
        , position absolute
        , left (px (leftSideWidth + 16))
        , right (px 8)
        , bottom (px 12)
        ]
    , (Css.class FocusedDrawing << List.append Html.Custom.indent)
        []
    , Css.class Drawing
        [ width (px 220)
        , marginLeft (px -10)
        , marginTop (px -10)
        , cursor pointer
        ]
    , (Css.class ProfilePictureContainer << List.append Html.Custom.indent)
        [ width (px (leftSideWidth - 4))
        , height (px (leftSideWidth - 4))
        , backgroundColor Ct.background2
        , overflow hidden
        ]
    , Css.class ProfilePicture
        [ width (px (leftSideWidth - 4)) ]
    , Css.class Profile
        []
    , Css.class BioContainer
        []
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
    , rightSide taco user model
    ]


rightSide : Taco -> User -> Model -> Html Msg
rightSide taco user model =
    case model.focusedDrawing of
        Just id ->
            case Id.get id taco.entities.drawings of
                Just drawing ->
                    focusedDrawingView drawing

                Nothing ->
                    errorView

        Nothing ->
            drawings (Id.items taco.entities.drawings)


focusedDrawingView : Drawing -> Html Msg
focusedDrawingView drawing =
    div
        [ class [ FocusedDrawingContainer ] ]
        [ img
            [ class [ FocusedDrawing ]
            , Attrs.src drawing.data
            ]
            []
        , p [] [ Html.text drawing.name ]
        ]


errorView : Html Msg
errorView =
    Html.text ""


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
        (drawingsChildren drawings)


drawingsChildren : List Drawing -> List (Html Msg)
drawingsChildren drawings =
    case drawings of
        [] ->
            [ noDrawingsView ]

        _ ->
            List.map drawing drawings
                ++ [ newDrawing ]


noDrawingsView : Html Msg
noDrawingsView =
    [ Html.Custom.header
        { text = "no drawings"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ p [] [ Html.text "You have no drawings" ] ]
    ]
        |> Html.Custom.cardSolitary []


newDrawing : Html Msg
newDrawing =
    [ Html.Custom.cardBody []
        [ p
            []
            [ Html.text ""
            ]
        ]
    ]
        |> Html.Custom.card
            [ class [ DrawingContainer ] ]


drawing : Drawing -> Html Msg
drawing drawing =
    [ Html.Custom.header
        { text = drawing.name
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ div
            [ class [ DrawingImageContainer ] ]
            [ img
                [ class [ Drawing ]
                , Attrs.src drawing.data
                , onClick (DrawingClicked drawing.id)
                ]
                []
            ]
        ]
    ]
        |> Html.Custom.card
            [ class [ DrawingContainer ] ]
