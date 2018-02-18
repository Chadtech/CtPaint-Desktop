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
import Html exposing (Attribute, Html, a, div, p, textarea)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput)
import Ports
import Random.Pcg as Random exposing (Generator, Seed)
import Set exposing (Set)
import Tracking
import Tuple.Infix exposing ((&))
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
    [ "upload url"
    , "upload to facebook"
    , "upload to twitter"
    , "layers"
    , "indexed palette"
    , "draw select"
    , "custom palettes"
    , "color gradient calculator"
    , "delete color from palette"
    , "animation"
    , "folders and project"
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
    , "svg software"
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
                model & Cmd.none
            else
                { model
                    | clickedWants =
                        Set.insert
                            want
                            model.clickedWants
                }
                    & trackCmd taco want

        OtherWantUpdated str ->
            if model.otherWantClicked then
                model & Cmd.none
            else
                { model
                    | otherWant = str
                }
                    & Cmd.none

        OtherWantClicked ->
            { model
                | otherWantClicked = True
            }
                & Util.cmdIf
                    (model.otherWant /= "")
                    (trackCmd taco ("Other want : " ++ model.otherWant))


trackCmd : Taco -> String -> Cmd Msg
trackCmd taco =
    Ports.track taco << Tracking.WantClicked



-- STYLES --


type Class
    = Text
    | Body
    | WantsContainer
    | Want
    | Clicked
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
    [ div
        [ class [ Body ] ]
        [ p
            [ class [ Text ] ]
            [ Html.text wantsSideText ]
        , wantsView model
        , suggestionBox model
        , suggestionSendButton model.otherWantClicked
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


wantsView : Model -> Html Msg
wantsView { clickedWants, wants } =
    div
        [ class [ WantsContainer ] ]
        (List.map (wantView clickedWants) wants)


suggestionBox : Model -> Html Msg
suggestionBox model =
    textarea
        [ classList
            [ ( Clicked, model.otherWantClicked )
            , ( OtherSuggestionBox, True )
            ]
        , onInput OtherWantUpdated
        , Attrs.placeholder "enter a suggestion here"
        , Attrs.spellcheck False
        , Attrs.value model.otherWant
        ]
        []


suggestionSendButton : Bool -> Html Msg
suggestionSendButton otherWantClicked =
    a
        [ classList
            [ ( SendSuggestionButton, True )
            , ( Clicked, otherWantClicked )
            ]
        , onClick OtherWantClicked
        ]
        [ Html.text "send suggestion" ]


wantsSideText : String
wantsSideText =
    """
    Below is a list of features I would like to implement into CtPaint.
    Click on the ones you would like to see added to CtPaint,
    so I can prioritize them in development.
    You can also fill in the suggestion field at the bottom and
    submit your own ideas.
    """


wantView : Set String -> String -> Html Msg
wantView clickedWants want =
    a
        (wantAttrs clickedWants want)
        [ Html.text want ]


wantAttrs : Set String -> String -> List (Attribute Msg)
wantAttrs clickedAlready want =
    if Set.member want clickedAlready then
        [ class [ Want, Clicked ] ]
    else
        [ class [ Want ]
        , onClick (WantClicked want)
        ]
