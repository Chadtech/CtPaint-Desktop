module Page.Settings
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.User exposing (User)
import Html exposing (Attribute, Html, a, div, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Reply exposing (Reply(NoReply, SetUser))
import Tuple.Infix exposing ((:=))


-- TYPES --


type alias Model =
    { page : Page
    , name : String
    , profilePicUrl : String
    }


type Field
    = Name
    | ProfilePicUrl


type Page
    = KeyConfig
    | UserData


type Msg
    = NavClickedOn Page
    | FieldUpdated Field String
    | Submitted



-- INIT --


init : User -> Model
init user =
    { page = UserData
    , name = user.name
    , profilePicUrl = user.profilePic
    }



-- UPDATE --


update : Msg -> User -> Model -> ( Model, Cmd Msg, Reply )
update msg user model =
    case msg of
        NavClickedOn page ->
            { model | page = page }
                |> Reply.nothing

        FieldUpdated Name str ->
            { model | name = str }
                |> Reply.nothing

        FieldUpdated ProfilePicUrl str ->
            { model | name = str }
                |> Reply.nothing

        Submitted ->
            model
                |> Reply.nothing



-- STYLES --


type Class
    = Body
    | Text
    | KeyConfigMsg
    | Long
    | Label
    | Input
    | Main
    | NavBar
    | NavBarButton
    | Selected


css : Stylesheet
css =
    [ Css.class Body
        [ width (px 800)
        , display block
        , margin auto
        ]
    , Css.class Label
        [ width (px 200) ]
    , Css.class Text
        [ marginBottom (px 8)
        , withClass KeyConfigMsg
            [ width (px 500) ]
        ]
    , Css.class Input
        [ width (px 400) ]
    , Css.class NavBar
        [ display inlineBlock
        , marginRight (px 8)
        , verticalAlign top
        , width (px 150)
        ]
    , Css.class NavBarButton
        [ display block
        , textAlign center
        , marginBottom (px 2)
        , withClass Selected
            Html.Custom.indent
        ]
    , Css.class Main
        [ display inlineBlock ]
    ]
        |> namespace settingsNamespace
        |> stylesheet


settingsNamespace : String
settingsNamespace =
    Html.Custom.makeNamespace "Settings"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace settingsNamespace


view : Model -> List (Html Msg)
view model =
    div
        [ class [ Body ] ]
        [ navBar model
        , div
            [ class [ Main ] ]
            (viewBody model)
        ]
        |> List.singleton


navBar : Model -> Html Msg
navBar model =
    let
        navButton_ : Page -> String -> Html Msg
        navButton_ =
            navButton model.page
    in
    div
        [ class [ NavBar ] ]
        [ navButton_ UserData "user"
        , navButton_ KeyConfig "key config"
        ]


navButton : Page -> Page -> String -> Html Msg
navButton currentPage thisPage label =
    a
        [ classList
            [ NavBarButton := True
            , Selected := (currentPage == thisPage)
            ]
        , onClick (NavClickedOn thisPage)
        ]
        [ Html.text label ]


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.page of
        KeyConfig ->
            keyConfig model

        UserData ->
            userDataView model


userDataView : Model -> List (Html Msg)
userDataView model =
    [ p
        [ class [ Text ] ]
        [ Html.text "user settings" ]
    , field
        "name"
        [ Attrs.value model.name
        , onInput_ Name
        ]
    , field
        "profile pic url"
        [ Attrs.value model.profilePicUrl
        , onInput_ ProfilePicUrl
        ]
    ]
        |> form [ onSubmit Submitted ]
        |> List.singleton


keyConfig : Model -> List (Html Msg)
keyConfig model =
    [ p
        [ class [ Text, KeyConfigMsg ] ]
        [ Html.text keyConfigMsg ]
    ]


keyConfigMsg : String
keyConfigMsg =
    """
    Sorry, this feature is not yet implemented. If
    you would like a custom key config, you can request
    it on the road map page. I would appreciate the feedback.
    """


field : String -> List (Attribute Msg) -> Html Msg
field name attributes =
    Html.Custom.field
        []
        [ p
            [ class [ Label ] ]
            [ Html.text name ]
        , input
            (class [ Input ] :: attributes)
            []
        ]



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
