module Page.RoadMap
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
import Data.Taco exposing (Taco)
import Data.User as User
import Html exposing (Attribute, Html, a, br, div, p, textarea)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput)
import Ports
import Random.Pcg as Random exposing (Generator, Seed)
import Return2 as R2
import Set exposing (Set)
import Tracking exposing (Event(PageRoadMapWantClick))
import Util


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
    shuffle wants >> Tuple.mapFirst fromWants


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


shuffle : List String -> Seed -> ( List String, Seed )
shuffle =
    shuffleHelper []


shuffleHelper : List String -> List String -> Seed -> ( List String, Seed )
shuffleHelper done remaining seed =
    case remaining of
        [] ->
            ( done, seed )

        first :: rest ->
            let
                ( ( randomElement, newRemaining ), newSeed ) =
                    Random.step (indexGenerator remaining) seed
                        |> Tuple.mapFirst (get first rest)
            in
            shuffleHelper
                (randomElement :: done)
                newRemaining
                newSeed


indexGenerator : List a -> Generator Int
indexGenerator list =
    Random.int 0 (List.length list - 1)


get : a -> List a -> Int -> ( a, List a )
get first rest index =
    case rest of
        [] ->
            ( first, [] )

        second :: rest_ ->
            if index == 0 then
                ( first, rest )
            else
                get second rest_ (index - 1)
                    |> Tuple.mapSecond ((::) first)



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        WantClicked want ->
            if Set.member want model.clickedWants then
                model
                    |> R2.withNoCmd
            else
                { model
                    | clickedWants =
                        Set.insert
                            want
                            model.clickedWants
                }
                    |> R2.withCmd (trackCmd taco want)

        OtherWantUpdated str ->
            if model.otherWantClicked then
                model
                    |> R2.withNoCmd
            else
                { model
                    | otherWant = str
                }
                    |> R2.withNoCmd

        OtherWantClicked ->
            { model
                | otherWantClicked = True
            }
                |> R2.withCmd (trackOtherWant taco model)


trackOtherWant : Taco -> Model -> Cmd Msg
trackOtherWant taco model =
    Util.cmdIf
        (model.otherWant /= "")
        (trackCmd taco ("Other want : " ++ model.otherWant))


trackCmd : Taco -> String -> Cmd Msg
trackCmd taco =
    Ports.track taco << PageRoadMapWantClick



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
