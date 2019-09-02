module Page.About exposing
    ( Model
    , Msg
    , getSession
    , getUser
    , handleRoute
    , init
    , mapSession
    , track
    , update
    , view
    )

import Chadtech.Colors as Colors
import Data.BuildNumber as BuildNumber exposing (BuildNumber)
import Data.Document exposing (Document)
import Data.Tracking as Tracking
import Data.User exposing (User)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Route
import Route.About exposing (Route)
import Session exposing (Session)
import Style
import Util.Cmd as CmdUtil
import Util.String as StringUtil
import View.BannerLogo as BannerLogo
import View.Body as Body
import View.Button as Button
import View.Text as Text
import View.TextArea as TextArea



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , user : User
    , route : Route
    , commentField : String
    , commentSent : Bool
    }


type Msg
    = CommentFieldUpdated String
    | SendCommentClicked
    | NavItemClicked Route



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> User -> Route -> Model
init session user route =
    { session = session
    , user = user
    , route = route
    , commentField = ""
    , commentSent = False
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getUser : Model -> User
getUser =
    .user


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }


handleRoute : Route -> Model -> Model
handleRoute =
    setRoute



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


setCommentField : String -> Model -> Model
setCommentField newField model =
    { model | commentField = newField }


commentSent : Model -> Model
commentSent model =
    { model | commentSent = True }


canSendComment : Model -> Bool
canSendComment model =
    not (model.commentSent || StringUtil.isBlank model.commentField)


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        session : Session
        session =
            getSession model

        navView : Route -> Body.NavItem Msg
        navView thisRoute =
            Body.navItem
                { onClick = NavItemClicked thisRoute
                , label = Route.About.toLabel thisRoute
                , active = thisRoute == model.route
                }
    in
    { title = Just "about"
    , body =
        Body.leftNavView
            { navItems = List.map navView Route.About.all
            , content = routeView model
            , styles = []
            , headerRows =
                [ BannerLogo.view
                    [ Style.sectionMarginVertical ]
                    (Session.getMountPath session)
                ]
            }
    }


routeView : Model -> List (Html Msg)
routeView model =
    let
        session : Session
        session =
            getSession model
    in
    case model.route of
        Route.About.Info ->
            let
                paragraphView : String -> Html msg
                paragraphView str =
                    Grid.row
                        [ Style.marginBottom 4 ]
                        [ Grid.column
                            []
                            [ Text.fromString str ]
                        ]
            in
            [ intro
            , personal
            , tech
            , thanks
            , String.join " "
                [ "This is build number"
                , BuildNumber.toString
                    (Session.getBuildNumber session)
                , "of this software"
                ]
            ]
                |> List.map paragraphView

        Route.About.Contact ->
            let
                email : String
                email =
                    getSession model
                        |> Session.getContactEmail
            in
            [ Grid.row
                [ Style.sectionMarginTop ]
                [ Grid.column
                    []
                    [ commentMessage email ]
                ]
            , Grid.row
                [ Style.sectionMarginTop ]
                [ Grid.column
                    [ Style.height 9 ]
                    (commentBox model)
                ]
            , Button.rowWithStyles
                [ Style.sectionMarginTop ]
                [ Button.config
                    SendCommentClicked
                    "send"
                    |> Button.isDisabled
                        (not <| canSendComment model)
                ]
            ]

        Route.About.RoadMap ->
            []


commentMessage : String -> Html msg
commentMessage email =
    Text.colorSegments
        [ ( """
        Send your  questions, comments, criticisms, and bug reports
        to
        """, Nothing )
        , ( email
          , Just Colors.important0
          )
        , ( """
        or fill out and submit the form below. I would love to hear from you!
        """
          , Nothing
          )
        ]


commentBox : Model -> List (Html Msg)
commentBox model =
    let
        text : String
        text =
            if model.commentSent then
                "Sent! Thank you"

            else
                model.commentField
    in
    [ TextArea.config
        CommentFieldUpdated
        text
        |> TextArea.withPlaceholder "enter your comment here"
        |> TextArea.isDisabled model.commentSent
        |> TextArea.withFullHeight
        |> TextArea.toHtml
    ]


intro : String
intro =
    """
    CtPaint is good paint software that runs in your web browser.
    Its broadly suited for drawing pixel art, drawing memes, or just
    making a quick practical drawings like diagrams or maps. Its also
    embedded in the internet, so its super easy to edit any image
    already on the internet, or share your drawings via a url.
    """


personal : String
personal =
    """
    It was made by one guy named "Chadtech" over the course of two years
    in his free time.
    """


tech : String
tech =
    """
    It was made with the following technology: Elm, Elm-Css, Elm-Canvas,
    Browserify, Amazon Web Services, and Gulp.
    """


thanks : String
thanks =
    """
    Ive worked on this project for a long time, and so I have worked with
    a lot of different people during the course of this project. In chronological
    order, here are my thank yous. Thanks to Funkytek who caused me to get into
    JavaScript whereafter I began working on CtPaint. Thanks to Jack Hou, a contributor
    to Chromium, who added 'image rendering : pixelated' to Google Chromium,
    a development I followed closely and has been essential to the technology
    behind CtPaint. Thanks to the meet ups NodeAZ, VegasJS, QueensJS, and
    Elm Berlin for letting me talk about CtPaint. Thanks to my friend Jacob
    Rosenthal who was always there to talk to me about code, and initially proposed
    the idea of doing a kickstarter. Thanks to Ethan Hartman, Taylor Alexander, and
    Alex Rees, all of whom were marketers who had great feedback about kickstarter campaigns.
    Thanks to Patrick Gram, Bob Laudner, and David Urbanic, who  did a really good job
    helping me put together my kickstarter video. Thanks to everyone who contributed to
    the original kick starter even tho it wasnt successful. Thanks Sascha Naderer,
    Andreas Kullenberg, Jun, Bo, and Erik 'Kasumi' from the pixelation community,
    for either their thorough and knowledgeable opinions on pixel art software, as
    well as their time using the CtPaint alpha to provide feedback, or the pixel art
    they have contributed to this project.
    """



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        session : Session
        session =
            getSession model
    in
    case msg of
        CommentFieldUpdated field ->
            if model.commentSent then
                model
                    |> CmdUtil.withNoCmd

            else
                model
                    |> setCommentField field
                    |> CmdUtil.withNoCmd

        SendCommentClicked ->
            if canSendComment model then
                ( commentSent model
                , Tracking.event "comment"
                    |> Tracking.withString "value" model.commentField
                    |> Tracking.send
                )

            else
                model
                    |> CmdUtil.withNoCmd

        NavItemClicked navItem ->
            ( model
            , Route.goToAbout
                (Session.getNavKey session)
                navItem
            )


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        SendCommentClicked ->
            Tracking.event "send comment click"

        CommentFieldUpdated _ ->
            Nothing

        NavItemClicked route ->
            Tracking.event "nav item clicked"
                |> Tracking.withString
                    "nav-item"
                    (Route.About.toLabel route)
