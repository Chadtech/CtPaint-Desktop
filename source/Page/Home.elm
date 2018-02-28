module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , drawingsLoaded
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
import Date exposing (Date)
import Date.Extra
import Html exposing (Html, a, div, img, p, text)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Html.Variables exposing (leftSideWidth)
import Id exposing (Id)
import Ports
    exposing
        ( JsMsg
            ( GetDrawings
            , OpenDrawingInPaintApp
            )
        )
import Reply exposing (Reply(NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = DrawingClicked Id
    | NewDrawingClicked
    | CloseDrawingClicked
    | HeaderMouseDown
    | OpenDrawingInCtPaint Id
    | DeleteDrawingClicked Id
    | DeleteYesClicked
    | DeleteNoClicked


type Model
    = SpecificDrawing Id
    | DeleteDrawing Id
    | DrawingsView
    | Loading
    | Deleting



-- INIT --


init : ( Model, Cmd Msg )
init =
    Loading & Ports.send GetDrawings



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        DrawingClicked id ->
            SpecificDrawing id
                |> Reply.nothing

        CloseDrawingClicked ->
            DrawingsView
                |> Reply.nothing

        HeaderMouseDown ->
            model |> Reply.nothing

        NewDrawingClicked ->
            model
                |> Reply.nothing

        OpenDrawingInCtPaint id ->
            ( model
            , Ports.send (OpenDrawingInPaintApp id)
            , NoReply
            )

        DeleteDrawingClicked id ->
            DeleteDrawing id
                |> Reply.nothing

        DeleteYesClicked ->
            case model of
                DeleteDrawing id ->
                    ( Deleting
                    , Ports.send (Ports.DeleteDrawing id)
                    , NoReply
                    )

                _ ->
                    model |> Reply.nothing

        DeleteNoClicked ->
            case model of
                DeleteDrawing id ->
                    SpecificDrawing id
                        |> Reply.nothing

                _ ->
                    model |> Reply.nothing


drawingsLoaded : Model -> Model
drawingsLoaded model =
    case model of
        Loading ->
            DrawingsView

        _ ->
            model



-- STYLES --


type Class
    = Drawings
    | DrawingContainer
    | DrawingImageContainer
    | FocusedDrawingContainer
    | FocusedDrawing
    | FocusedDrawingText
    | Drawing
    | CenteredCard
    | Text
    | Button
    | ButtonsContainer
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
        [ position relative
        , display inlineBlock
        , translate2 (pct -50) (pct -50)
            |> transform
        , top (pct 50)
        , left (pct 50)
        ]
    , Css.class FocusedDrawingText
        [ marginBottom (px 8) ]
    , (Css.class FocusedDrawing << List.append Html.Custom.indent)
        [ marginBottom (px 8) ]
    , Css.class Drawing
        [ width (px 220)
        , marginLeft (px -10)
        , marginTop (px -10)
        , cursor pointer
        ]
    , Css.class CenteredCard
        [ position relative
        , display inlineBlock
        , translate2 (pct -50) (pct -50)
            |> transform
        , top (pct 50)
        , left (pct 50)
        ]
    , Css.class Text
        [ marginBottom (px 8) ]
    , Css.class ButtonsContainer
        [ justifyContent center
        , displayFlex
        ]
    , Css.class Button
        [ marginLeft (px 8) ]
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
    , div
        [ class [ Drawings ] ]
        (rightSide taco user model)
    ]


rightSide : Taco -> User -> Model -> List (Html Msg)
rightSide taco user model =
    case model of
        SpecificDrawing id ->
            case Id.get id taco.entities.drawings of
                Just drawing ->
                    [ focusedDrawingView drawing ]

                Nothing ->
                    [ errorView ]

        Loading ->
            [ loadingView ]

        DrawingsView ->
            drawings (Id.items taco.entities.drawings)

        DeleteDrawing id ->
            case Id.get id taco.entities.drawings of
                Just drawing ->
                    [ deleteDrawingView drawing ]

                Nothing ->
                    [ errorView ]

        Deleting ->
            [ deletingView ]


deleteDrawingView : Drawing -> Html Msg
deleteDrawingView drawing =
    [ Html.Custom.header
        { text = "delete drawing"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ p
            [ class [ Text ] ]
            [ Html.text (deleteStr drawing) ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ class [ Button ]
                , onClick DeleteYesClicked
                ]
                [ Html.text "yes" ]
            , a
                [ class [ Button ]
                , onClick DeleteNoClicked
                ]
                [ Html.text "no" ]
            ]
        ]
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


deleteStr : Drawing -> String
deleteStr { name } =
    [ "Are you sure you want to delete \""
    , name
    , "\"?"
    ]
        |> String.concat


loadingView : Html Msg
loadingView =
    [ Html.Custom.header
        { text = "loading drawings"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ p
            [ class [ Text ] ]
            [ Html.text "please wait" ]
        , Html.Custom.spinner
        ]
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


deletingView : Html Msg
deletingView =
    [ Html.Custom.header
        { text = "deleting drawing"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ p
            [ class [ Text ] ]
            [ Html.text "please wait" ]
        , Html.Custom.spinner
        ]
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


focusedDrawingView : Drawing -> Html Msg
focusedDrawingView drawing =
    [ Html.Custom.header
        { text = drawing.name
        , closability =
            { headerMouseDown = always HeaderMouseDown
            , xClick = CloseDrawingClicked
            }
                |> Html.Custom.Closable
        }
    , Html.Custom.cardBody []
        [ img
            [ class [ FocusedDrawing ]
            , Attrs.src drawing.data
            ]
            []
        , p
            [ class [ FocusedDrawingText ] ]
            [ Html.text ("created at : " ++ formatDate drawing.createdAt) ]
        , p
            [ class [ FocusedDrawingText ] ]
            [ Html.text ("updated at : " ++ formatDate drawing.updatedAt) ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ class [ Button ]
                , onClick (OpenDrawingInCtPaint drawing.id)
                ]
                [ Html.text "open in ctpaint" ]
            , a
                [ class [ Button ]
                , onClick (DeleteDrawingClicked drawing.id)
                ]
                [ Html.text "delete" ]
            ]
        ]
    ]
        |> Html.Custom.card
            [ class [ FocusedDrawingContainer ] ]


formatDate : Date -> String
formatDate =
    Date.Extra.toFormattedString "y/M/d H:m"


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


drawings : List Drawing -> List (Html Msg)
drawings drawings =
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
