module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , drawingDeleted
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
import Html.InitDrawing as InitDrawing
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
    | CloseNewDrawingClicked
    | InitDrawingMsg InitDrawing.Msg
    | HeaderMouseDown
    | OpenDrawingInCtPaint Id
    | DeleteDrawingClicked Id
    | DeleteYesClicked
    | DeleteNoClicked
    | BackToDrawingsClicked
    | TryAgainClicked Id


type Model
    = SpecificDrawing Id
    | DeleteDrawing Id
    | DrawingsView
    | Loading
    | Deleting
    | Deleted String
    | DidntDelete Id
    | NewDrawing InitDrawing.Model



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
            goToDrawingsView

        CloseNewDrawingClicked ->
            goToDrawingsView

        HeaderMouseDown ->
            model |> Reply.nothing

        NewDrawingClicked ->
            InitDrawing.init
                |> NewDrawing
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
                    delete id

                _ ->
                    model |> Reply.nothing

        DeleteNoClicked ->
            case model of
                DeleteDrawing id ->
                    SpecificDrawing id
                        |> Reply.nothing

                _ ->
                    model |> Reply.nothing

        BackToDrawingsClicked ->
            DrawingsView |> Reply.nothing

        TryAgainClicked id ->
            case model of
                DidntDelete id ->
                    delete id

                _ ->
                    model |> Reply.nothing

        InitDrawingMsg subMsg ->
            case model of
                NewDrawing subModel ->
                    handleInitMsg subMsg subModel

                _ ->
                    model |> Reply.nothing


handleInitMsg : InitDrawing.Msg -> InitDrawing.Model -> ( Model, Cmd Msg, Reply )
handleInitMsg subMsg subModel =
    let
        ( newSubModel, cmd ) =
            InitDrawing.update subMsg subModel
    in
    ( NewDrawing newSubModel
    , Cmd.map InitDrawingMsg cmd
    , NoReply
    )


delete : Id -> ( Model, Cmd Msg, Reply )
delete id =
    ( Deleting
    , Ports.send (Ports.DeleteDrawing id)
    , NoReply
    )


goToDrawingsView : ( Model, Cmd Msg, Reply )
goToDrawingsView =
    DrawingsView |> Reply.nothing


drawingsLoaded : Model -> Model
drawingsLoaded model =
    case model of
        Loading ->
            DrawingsView

        _ ->
            model


drawingDeleted : Result Id String -> Model -> Model
drawingDeleted result model =
    case ( result, model ) of
        ( Ok name, Deleting ) ->
            Deleted name

        ( Err id, Deleting ) ->
            DidntDelete id

        _ ->
            model



-- STYLES --


type Class
    = DrawingsContainer
    | DrawingContainer
    | DrawingImageContainer
    | FocusedDrawingContainer
    | FocusedDrawing
    | FocusedDrawingText
    | NewDrawingCard
    | NewDrawingText
    | Drawing
    | CenteredCard
    | Text
    | Button
    | ButtonsContainer
    | ProfilePictureContainer
    | ProfilePicture
    | Profile
    | BioContainer
    | ErrorBody
    | Name
    | LeftSide


css : Stylesheet
css =
    [ (Css.class DrawingsContainer << List.append Html.Custom.indent)
        [ position absolute
        , top (px 8)
        , left (px (leftSideWidth + 16))
        , right (px 8)
        , bottom (px 12)
        , backgroundColor Ct.background2
        , paddingRight (px 8)
        ]
    , Css.class DrawingContainer
        [ marginTop (px 8)
        , marginLeft (px 8)
        , display inlineBlock
        , position relative
        , overflow auto
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
    , Css.class NewDrawingCard
        [ cursor pointer
        , active Html.Custom.indent
        ]
    , Css.class NewDrawingText
        [ height (px 204)
        , width (px 204)
        , verticalAlign middle
        , textAlign center
        , display tableCell
        , paddingBottom (px 32)
        ]
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
        , margin (px 8)
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
    , Css.class ErrorBody
        [ backgroundColor Ct.lowWarning ]
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
        [ class [ DrawingsContainer ] ]
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

        Deleted name ->
            [ deletedView name ]

        DidntDelete id ->
            case Id.get id taco.entities.drawings of
                Just drawing ->
                    [ deleteFailedView drawing ]

                Nothing ->
                    [ errorView ]

        NewDrawing subModel ->
            [ newDrawingView subModel ]


newDrawingView : InitDrawing.Model -> Html Msg
newDrawingView subModel =
    [ Html.Custom.header
        { text = "new drawing"
        , closability =
            { headerMouseDown = always HeaderMouseDown
            , xClick = CloseNewDrawingClicked
            }
                |> Html.Custom.Closable
        }
    , InitDrawing.view subModel
        |> Html.map InitDrawingMsg
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


deleteFailedView : Drawing -> Html Msg
deleteFailedView { name, id } =
    [ Html.Custom.header
        { text = "delete failed"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody
        [ class [ ErrorBody ] ]
        [ p
            [ class [ Text ] ]
            [ Html.text (didntDeleteStr name) ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ class [ Button ]
                , onClick (TryAgainClicked id)
                ]
                [ Html.text "try again" ]
            , a
                [ class [ Button ]
                , onClick BackToDrawingsClicked
                ]
                [ Html.text "go back to drawings" ]
            ]
        ]
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


didntDeleteStr : String -> String
didntDeleteStr name =
    [ "Something didnt work. "
    , "\""
    , name
    , "\" might not have been deleted."
    ]
        |> String.concat


deletedView : String -> Html Msg
deletedView name =
    [ Html.Custom.header
        { text = "delete complete"
        , closability = Html.Custom.NotClosable
        }
    , Html.Custom.cardBody []
        [ p
            [ class [ Text ] ]
            [ Html.text (deletedStr name) ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ class [ Button ]
                , onClick BackToDrawingsClicked
                ]
                [ Html.text "go back to drawings" ]
            ]
        ]
    ]
        |> Html.Custom.card [ class [ CenteredCard ] ]


deletedStr : String -> String
deletedStr name =
    [ "\""
    , name
    , "\" has been deleted"
    ]
        |> String.concat


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
    Date.Extra.toFormattedString "y/MM/dd HH:mm"


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
            drawings
                |> List.map drawing
                |> flip List.append [ newDrawing ]


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
    [ Html.Custom.cardBody
        []
        [ p
            [ class [ NewDrawingText ] ]
            [ Html.text "Add new drawing" ]
        ]
    ]
        |> Html.Custom.card
            [ class
                [ NewDrawingCard
                , DrawingContainer
                ]
            , onClick NewDrawingClicked
            ]


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
