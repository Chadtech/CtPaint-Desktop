module Page.Settings
    exposing
        ( Model
        , Msg
        , Reply(..)
        , css
        , failed
        , init
        , succeeded
        , track
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html exposing (Attribute, Html, a, div, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode as Encode
import Ports
    exposing
        ( JsMsg(UpdateUser)
        , UpdatePayload
        )
import Return2 as R2
import Return3 as R3 exposing (Return)
import Util exposing (def)


-- TYPES --


type alias Model =
    { page : Page
    , name : String
    , profilePicUrl : String
    , changed : Bool
    , state : State
    }


type State
    = Ready
    | Sending
    | Fail


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
    | SaveClicked
    | SaveSucceeded
    | SaveFailed String


type Reply
    = SetUser User


succeeded : Msg
succeeded =
    SaveSucceeded


failed : String -> Msg
failed =
    SaveFailed



-- INIT --


init : User -> Model
init user =
    { page = UserData
    , name = user.name
    , profilePicUrl = Maybe.withDefault "" user.profilePic
    , changed = False
    , state = Ready
    }



-- UPDATE --


update : Msg -> User -> Model -> Return Model Msg Reply
update msg user model =
    case msg of
        NavClickedOn page ->
            { model | page = page }
                |> R3.withNothing

        FieldUpdated Name str ->
            { model | name = str }
                |> validate user
                |> R3.withNothing

        FieldUpdated ProfilePicUrl str ->
            { model | profilePicUrl = str }
                |> validate user
                |> R3.withNothing

        Submitted ->
            model
                |> R3.withNothing

        SaveClicked ->
            if canSave model then
                model
                    |> toUpdatePayload user
                    |> UpdateUser
                    |> Ports.send
                    |> R2.withModel { model | state = Sending }
                    |> R3.withNoReply
            else
                model
                    |> R3.withNothing

        SaveSucceeded ->
            { model | state = Ready }
                |> R3.withNothing

        SaveFailed _ ->
            { model | state = Fail }
                |> R3.withNothing


toUpdatePayload : User -> Model -> UpdatePayload
toUpdatePayload srcUser model =
    { email = srcUser.email
    , name = model.name
    , profilePicUrl =
        case model.profilePicUrl of
            "" ->
                "NONE"

            _ ->
                model.profilePicUrl
    }


validate : User -> Model -> Model
validate srcUser model =
    { model | changed = hasChanges model srcUser }


toUser : Model -> User -> User
toUser model srcUser =
    { email = srcUser.email
    , name = model.name
    , profilePic =
        case model.profilePicUrl of
            "" ->
                Nothing

            _ ->
                Just model.profilePicUrl
    , keyConfig = srcUser.keyConfig
    }


hasChanges : Model -> User -> Bool
hasChanges model srcUser =
    toUser model srcUser /= srcUser


canSave : Model -> Bool
canSave model =
    model.changed && model.state == Ready



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        NavClickedOn page ->
            [ def "nav-page" <| Encode.string (toString page) ]
                |> def "nav click"
                |> Just

        FieldUpdated _ _ ->
            Nothing

        Submitted ->
            Tracking.noProps "submit enter press"

        SaveClicked ->
            [ model
                |> canSave
                |> not
                |> Encode.bool
                |> def "is-disabled"
            ]
                |> def "save click"
                |> Just

        SaveSucceeded ->
            Nothing
                |> trackResponse

        SaveFailed err ->
            err
                |> Just
                |> trackResponse


trackResponse : Maybe String -> Maybe Tracking.Event
trackResponse =
    Tracking.response >> Tracking.namespace "save"



-- STYLES --


type Class
    = Body
    | Text
    | KeyConfigMsg
    | Label
    | Input
    | Main
    | NavBar
    | NavBarButton
    | Selected
    | Save
    | Disabled


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
    , Css.class Save
        [ display table
        , margin auto
        , withClass Disabled
            [ backgroundColor Ct.ignorable1
            , active Html.Custom.outdent
            ]
        ]
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
            [ def NavBarButton True
            , def Selected (currentPage == thisPage)
            ]
        , onClick (NavClickedOn thisPage)
        ]
        [ Html.text label ]


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.state of
        Ready ->
            readyView model

        Sending ->
            sendingView

        Fail ->
            failView


sendingView : List (Html Msg)
sendingView =
    [ Html.Custom.spinner ]


failView : List (Html Msg)
failView =
    """
    Sorry, I wasnt able to update your user settings. Something
    went wrong. If this problem persists please report this as
    a bug.
    """
        |> Html.text
        |> List.singleton
        |> p []
        |> List.singleton


readyView : Model -> List (Html Msg)
readyView model =
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
    , saveButton model
    ]
        |> form [ onSubmit Submitted ]
        |> List.singleton


saveButton : Model -> Html Msg
saveButton model =
    a
        [ classList
            [ def Save True
            , def Disabled (not model.changed)
            ]
        , onClick SaveClicked
        ]
        [ Html.text "save" ]


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
            (inputAttrs attributes)
            []
        ]


inputAttrs : List (Attribute Msg) -> List (Attribute Msg)
inputAttrs =
    [ class [ Input ]
    , Attrs.spellcheck False
    ]
        |> List.append



-- HELPERS --


onInput_ : Field -> Attribute Msg
onInput_ =
    FieldUpdated >> onInput
