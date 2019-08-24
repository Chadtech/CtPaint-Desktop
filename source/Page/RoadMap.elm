module Page.RoadMap exposing
    ( Model
    , Msg
    , css
    , init
    , track
    , update
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Data.Account as User
import Data.Taco exposing (Taco)
import Data.Tracking as Tracking
import Html exposing (Attribute, Html, a, div, p, textarea)
import Html.Attributes as Attrs
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
import Random exposing (Seed)
import Set exposing (Set)
import Util exposing (def)
import Util.Random as RandomUtil



-- TYPES --


type alias Model =
    { wants : List String
    , clickedWants : Set String
    , otherWant : String
    , otherWantClicked : Bool
    }


type Msg
    = WantClicked String
    | OtherWantUpdated String
    | OtherWantClicked



-- INIT --


init : Seed -> ( Model, Seed )
init =
    RandomUtil.shuffle wants
        >> Tuple.mapFirst fromWants


fromWants : List String -> Model
fromWants wants =
    { wants = wants
    , clickedWants = Set.empty
    , otherWant = ""
    , otherWantClicked = False
    }


wants : List String
wants =
    [ "upload to facebook"
    , "upload to twitter"
    , "layers"
    , "indexed palette"
    , "draw select"
    , "custom palettes"
    , "color gradient calculator"
    , "delete color from palette"
    , "animation"
    , "folders and projects"
    , "collaboration and sharing"
    , "spray can"
    , "transparency"
    , "contrast control"
    , "saturation control"
    , "lightness control"
    , "brushes"
    , "blob / contour tool"
    , "multi-select palette colors"
    , "circle tool"
    , "blur"
    , "customizable key commands"
    , "unlimited storage"
    , "private drawings"
    , "search all ctpaint images"
    , "svg software"
    , "imgur upload"
    , "local storage"
    , "animated gifs"
    , "percise rotating"
    , "google chrome extension"
    , "draw on selection"
    , "more undo history"

    -- ???
    ]



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        WantClicked want ->
            { model
                | clickedWants =
                    Set.insert
                        want
                        model.clickedWants
            }

        OtherWantUpdated str ->
            { model
                | otherWant = str
            }

        OtherWantClicked ->
            { model
                | otherWantClicked = True
            }



-- TRACKING --


track : Msg -> Model -> Maybe Tracking.Event
track msg model =
    case msg of
        WantClicked want ->
            if hasAlreadyBeenClicked want model then
                Nothing

            else
                want
                    |> Encode.string
                    |> def "want"
                    |> List.singleton
                    |> def "want click"
                    |> Just

        OtherWantUpdated _ ->
            Nothing

        OtherWantClicked ->
            if model.otherWantClicked then
                Nothing

            else
                model.otherWant
                    |> (++) "Other want : "
                    |> Encode.string
                    |> def "want"
                    |> List.singleton
                    |> def "want click"
                    |> Just


hasAlreadyBeenClicked : String -> Model -> Bool
hasAlreadyBeenClicked want model =
    Set.member want model.clickedWants



-- STYLES --


type Class
    = Text
    | Body
    | WantsContainer
    | Want
    | Clicked
    | Disabled
    | OtherSuggestionBox
    | SendSuggestionButton
    | Divider


css : Stylesheet
css =
    [ Css.class Text
        [ marginBottom (px 8) ]
    , Css.class Body
        [ width (px 800)
        , display block
        , margin auto
        ]
    , Css.class WantsContainer
        [ display block
        , minWidth fitContent
        , overflow auto
        ]
    , (Css.class Want << List.append Html.Custom.outdent)
        [ display block
        , textAlign center
        , float left
        , width (px 378)
        , margin (px 1)
        ]
    , (Css.class Clicked << List.append Html.Custom.indent)
        [ backgroundColor Ct.ignorable1
        , hover [ color Ct.point0 ]
        ]
    , Css.class Disabled
        [ backgroundColor Ct.ignorable1
        , hover [ color Ct.point0 ]
        ]
    , (Css.class OtherSuggestionBox << List.append Html.Custom.indent)
        [ outline none
        , fontFamilies [ "hfnss" ]
        , fontSize (em 2)
        , backgroundColor Ct.background2
        , color Ct.point0
        , width (px 798)
        , height (px 128)
        , marginBottom (px 8)
        , property "-webkit-font-smoothing" "none"
        , display block
        , margin2 (px 8) auto
        , resize none
        , padding (px 8)
        , withClass Clicked
            [ backgroundColor Ct.ignorable1 ]
        , withClass Disabled
            [ backgroundColor Ct.ignorable1 ]
        ]
    , Css.class SendSuggestionButton
        [ display table
        , margin2 (px 8) auto
        , withClass Clicked Html.Custom.outdent
        ]
    , (Css.class Divider << List.append Html.Custom.indent)
        [ width (px 800)
        , margin auto
        , display block
        , marginBottom (px 8)
        ]
    ]
        |> namespace roadMapNamespace
        |> stylesheet


roadMapNamespace : String
roadMapNamespace =
    Html.Custom.makeNamespace "RoadMap"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace roadMapNamespace


view : Taco -> Model -> List (Html Msg)
view taco model =
    let
        isLoggedIn =
            User.isLoggedIn taco.user
    in
    [ div
        [ class [ Body ] ]
        [ p
            [ class [ Text ] ]
            [ Html.text (wantsSideText isLoggedIn) ]
        , wantsView isLoggedIn model
        , suggestionBox isLoggedIn model
        , suggestionSendButton isLoggedIn model.otherWantClicked
        , div
            [ class [ Divider ] ]
            []
        , p
            [ class [ Text ] ]
            [ Html.text immediateFeatures ]
        ]
    ]


immediateFeatures : String
immediateFeatures =
    """
    In the immediate future, I will be working on the
    silver subscription tier of ctpaint, url image sharing,
    and social media posting. In the more distant future
    I would like to develope a more advanced version of
    CtPaint with features more suited towards pixel artists.
    """


wantsView : Bool -> Model -> Html Msg
wantsView isLoggedIn { clickedWants, wants } =
    div
        [ class [ WantsContainer ] ]
        (List.map (wantView isLoggedIn clickedWants) wants)


suggestionBox : Bool -> Model -> Html Msg
suggestionBox isLoggedIn model =
    textarea (suggestionBoxAttrs isLoggedIn model) []


suggestionBoxAttrs : Bool -> Model -> List (Attribute Msg)
suggestionBoxAttrs isLoggedIn model =
    [ classList
        [ ( Clicked, model.otherWantClicked )
        , ( Disabled, not isLoggedIn )
        , ( OtherSuggestionBox, True )
        ]
    , Attrs.placeholder (suggestionPlaceholder isLoggedIn)
    , Attrs.spellcheck False
    , Attrs.value model.otherWant
    ]
        |> Util.maybeCons (shouldInput isLoggedIn)


shouldInput : Bool -> Maybe (Attribute Msg)
shouldInput isLoggedIn =
    if isLoggedIn then
        Just (onInput OtherWantUpdated)

    else
        Nothing


suggestionPlaceholder : Bool -> String
suggestionPlaceholder isLoggedIn =
    if isLoggedIn then
        "enter a suggestion here"

    else
        "you must be logged into send suggestions"


suggestionSendButton : Bool -> Bool -> Html Msg
suggestionSendButton isLoggedIn otherWantClicked =
    a
        [ classList
            [ ( SendSuggestionButton, True )
            , ( Clicked, otherWantClicked )
            , ( Disabled, not isLoggedIn )
            ]
        , onClick OtherWantClicked
        ]
        [ Html.text "send suggestion" ]


wantsSideText : Bool -> String
wantsSideText isLoggedIn =
    if isLoggedIn then
        """
        Below is a list of features I would like to implement into CtPaint.
        Click on the ones you would like to see added to CtPaint,
        and I will get a message letting me know. This helps me prioritize
        features. You can also fill in the suggestion field at the bottom and
        submit your own ideas.
        """

    else
        """
        Below is a list of features I would like to implement into CtPaint.
        If you log in, you can click on the ones you would like to see added
        to CtPaint, and I will get a message letting me know. This helps me
        prioritize features. They will remain disabled until you log in.
        """


wantView : Bool -> Set String -> String -> Html Msg
wantView isLoggedIn clickedWants want =
    a
        (wantAttrs isLoggedIn clickedWants want)
        [ Html.text want ]


wantAttrs : Bool -> Set String -> String -> List (Attribute Msg)
wantAttrs isLoggedIn clickedAlready want =
    if not isLoggedIn then
        [ class [ Want, Disabled ] ]

    else if Set.member want clickedAlready then
        [ class [ Want, Clicked ] ]

    else
        [ class [ Want ]
        , onClick (WantClicked want)
        ]
