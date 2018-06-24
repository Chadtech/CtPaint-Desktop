module Page.Home
    exposing
        ( Model
        , Msg
        , css
        , drawingDeleted
        , drawingsLoaded
        , init
        , track
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Drawing as Drawing exposing (Drawing)
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Date exposing (Date)
import Date.Extra
import Html exposing (Html, a, div, img, input, p)
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
            , OpenInNewWindow
            )
        )
import Return2 as R2
import Util exposing (def)


-- TYPES --


type Msg
    = DrawingClicked Id
    | NewDrawingClicked
    | CloseDrawingClicked
    | CloseNewDrawingClicked
    | InitDrawingMsg InitDrawing.Msg
    | HeaderMouseDown
    | OpenDrawingInCtPaint Id
    | OpenDrawingLink Id
    | DeleteDrawingClicked Id
    | DeleteYesClicked
    | DeleteNoClicked
    | MakeADrawingClicked
    | RefreshClicked
    | BackToDrawingsClicked
    | TryAgainClicked Id


type alias Model =
    -- Right now this record is not necessary
    -- but I expect the model to grow
    -- in which case it will inevitably
    -- need to be a record
    { main : Main }


type Main
    = SpecificDrawing Id
    | DeleteDrawing Id
    | DrawingsView
    | Loading Loadable
    | Deleting
    | Deleted String
    | DidntDelete Id
    | NewDrawing InitDrawing.Model


type Loadable
    = AllDrawings
    | OneDrawing



-- INIT --


init : ( Model, Cmd Msg )
init =
    { main = Loading AllDrawings }
        |> R2.withCmd (Ports.send GetDrawings)



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DrawingClicked id ->
            SpecificDrawing id
                |> setMain model
                |> R2.withNoCmd

        CloseDrawingClicked ->
            goToDrawingsView
                |> R2.mapModel (setMain model)

        CloseNewDrawingClicked ->
            goToDrawingsView
                |> R2.mapModel (setMain model)

        HeaderMouseDown ->
            model
                |> R2.withNoCmd

        NewDrawingClicked ->
            InitDrawing.init
                |> NewDrawing
                |> setMain model
                |> R2.withNoCmd

        OpenDrawingInCtPaint id ->
            OpenDrawingInPaintApp id
                |> Ports.send
                |> R2.withModel (Loading OneDrawing)
                |> R2.mapModel (setMain model)

        OpenDrawingLink id ->
            id
                |> Drawing.toUrl
                |> OpenInNewWindow
                |> Ports.send
                |> R2.withModel model

        DeleteDrawingClicked id ->
            DeleteDrawing id
                |> setMain model
                |> R2.withNoCmd

        DeleteYesClicked ->
            case model.main of
                DeleteDrawing id ->
                    delete id
                        |> R2.mapModel (setMain model)

                _ ->
                    model
                        |> R2.withNoCmd

        DeleteNoClicked ->
            case model.main of
                DeleteDrawing id ->
                    SpecificDrawing id
                        |> setMain model
                        |> R2.withNoCmd

                _ ->
                    model
                        |> R2.withNoCmd

        MakeADrawingClicked ->
            InitDrawing.init
                |> NewDrawing
                |> setMain model
                |> R2.withNoCmd

        RefreshClicked ->
            Ports.send GetDrawings
                |> R2.withModel (Loading AllDrawings)
                |> R2.mapModel (setMain model)

        BackToDrawingsClicked ->
            DrawingsView
                |> setMain model
                |> R2.withNoCmd

        TryAgainClicked _ ->
            case model.main of
                DidntDelete id ->
                    delete id
                        |> R2.mapModel (setMain model)

                _ ->
                    model
                        |> R2.withNoCmd

        InitDrawingMsg subMsg ->
            case model.main of
                NewDrawing subModel ->
                    handleInitMsg subMsg subModel
                        |> R2.mapModel (setMain model)

                _ ->
                    model
                        |> R2.withNoCmd


setMain : Model -> Main -> Model
setMain model main =
    { model | main = main }


handleInitMsg : InitDrawing.Msg -> InitDrawing.Model -> ( Main, Cmd Msg )
handleInitMsg subMsg subModel =
    subModel
        |> InitDrawing.update subMsg
        |> R2.mapModel NewDrawing
        |> R2.mapCmd InitDrawingMsg


delete : Id -> ( Main, Cmd Msg )
delete id =
    Ports.DeleteDrawing id
        |> Ports.send
        |> R2.withModel Deleting


goToDrawingsView : ( Main, Cmd Msg )
goToDrawingsView =
    DrawingsView
        |> R2.withNoCmd


drawingsLoaded : Model -> Model
drawingsLoaded model =
    case model.main of
        Loading AllDrawings ->
            DrawingsView
                |> setMain model

        _ ->
            model


drawingDeleted : Result Id String -> Model -> Model
drawingDeleted result model =
    case ( result, model.main ) of
        ( Ok name, Deleting ) ->
            Deleted name
                |> setMain model

        ( Err id, Deleting ) ->
            DidntDelete id
                |> setMain model

        _ ->
            model



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        DrawingClicked id ->
            id
                |> Id.encode
                |> def "id"
                |> List.singleton
                |> def "drawing click"
                |> Just

        CloseDrawingClicked ->
            Tracking.noProps "close-drawing click"

        CloseNewDrawingClicked ->
            Tracking.noProps "close-new-drawing click"

        NewDrawingClicked ->
            Tracking.noProps "new-drawing click"

        OpenDrawingInCtPaint id ->
            id
                |> Id.encode
                |> def "id"
                |> List.singleton
                |> def "open-drawing-in-ctpaint click"
                |> Just

        OpenDrawingLink id ->
            id
                |> Id.encode
                |> def "id"
                |> List.singleton
                |> def "open-drawing-link click"
                |> Just

        DeleteDrawingClicked id ->
            id
                |> Id.encode
                |> def "id"
                |> List.singleton
                |> def "delete-drawing click"
                |> Just

        DeleteYesClicked ->
            Tracking.noProps "delete-drawing-yes click"

        DeleteNoClicked ->
            Tracking.noProps "delete-drawing-no click"

        MakeADrawingClicked ->
            Tracking.noProps "make-a-drawing click"

        RefreshClicked ->
            Tracking.noProps "refresh click"

        BackToDrawingsClicked ->
            Tracking.noProps "back-to-drawings click"

        TryAgainClicked _ ->
            Tracking.noProps "try-again click"

        InitDrawingMsg subMsg ->
            case model.main of
                NewDrawing subModel ->
                    subModel
                        |> InitDrawing.track subMsg
                        |> Tracking.namespace "init-drawing"

                _ ->
                    Nothing

        HeaderMouseDown ->
            Nothing



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
    | DrawingLinkContainer
    | DrawingLink
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
        [ display block
        , margin auto
        , marginBottom (px 8)
        ]
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
    , Css.class DrawingLinkContainer
        [ children
            [ Css.Elements.p
                [ marginRight (px 8)
                , display inlineBlock
                ]
            ]
        , marginBottom (px 8)
        ]
    , Css.class DrawingLink
        [ width (px 300) ]
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
        [ width (px (leftSideWidth - 4))
        , before
            [ property "content" "\" \""
            , display block
            , position absolute
            , width (px (leftSideWidth - 4))
            , height (px (leftSideWidth - 4))
            , backgroundImage (url "https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads/48554601-77c9-11e8-8628-7b3dcff52954")
            , property "background-size" "150px 150px"
            ]
        ]
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


view : Taco -> User -> Model -> List (Html Msg)
view taco user model =
    [ leftSide user
    , div
        [ class [ DrawingsContainer ] ]
        (rightSide taco model)
    ]


rightSide : Taco -> Model -> List (Html Msg)
rightSide taco model =
    case model.main of
        SpecificDrawing id ->
            case Id.get id taco.entities.drawings of
                Just drawing ->
                    [ focusedDrawingView drawing ]

                Nothing ->
                    [ errorView ]

        Loading AllDrawings ->
            [ loadingView "loading drawings" ]

        Loading OneDrawing ->
            [ loadingView "loading" ]

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


loadingView : String -> Html Msg
loadingView str =
    [ Html.Custom.header
        { text = str
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
            [ class [ DrawingLinkContainer ] ]
            [ p
                []
                [ Html.text "image link" ]
            , input
                [ class [ DrawingLink ]
                , Attrs.disabled True
                , Attrs.value (Drawing.toUrl drawing.id)
                , Attrs.autofocus True
                , Attrs.attribute "onfocus" "this.select()"
                ]
                []
            ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ onClick (OpenDrawingLink drawing.publicId) ]
                [ Html.text "open image link" ]
            , a
                [ class [ Button ]
                , onClick (OpenDrawingInCtPaint drawing.publicId)
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


profilePicture : Maybe String -> Html Msg
profilePicture url =
    div
        [ class [ ProfilePictureContainer ] ]
        [ img
            [ class [ ProfilePicture ]
            , Attrs.src <| Maybe.withDefault "" url
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
        [ p
            [ class [ Text ] ]
            [ Html.text "you dont have any drawings" ]
        , div
            [ class [ ButtonsContainer ] ]
            [ a
                [ onClick RefreshClicked ]
                [ Html.text "refresh drawings" ]
            , a
                [ class [ Button ]
                , onClick MakeADrawingClicked
                ]
                [ Html.text "make a drawing" ]
            ]
        ]
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
