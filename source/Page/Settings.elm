module Page.Settings exposing
    ( Model
    , Msg
    , getAccount
    , getSession
    , init
    , mapSession
    , track
    , update
    , view
    )

import Bool.Extra
import Css
import Data.Account as Account exposing (Account)
import Data.Document exposing (Document)
import Data.Field as Field exposing (Field)
import Data.Listener as Listener
import Data.Tracking as Tracking
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Ports
import Session exposing (Session)
import Style
import Util.Cmd as CmdUtil
import View.Body as Body
import View.Button as Button
import View.Input as Input
import View.InputGroup as InputGroup
import View.Spinner as Spinner
import View.Text as Text



-------------------------------------------------------------------------------
-- TYPES --
-------------------------------------------------------------------------------


type alias Model =
    { session : Session
    , account : Account
    , tab : Tab
    , nameField : Field
    , status : HttpStatus
    }


type HttpStatus
    = Ready
    | Saving
    | Fail (Listener.Error String)


type Tab
    = Account
    | KeyConfig


type Msg
    = TabClickedOn Tab
    | NameUpdated String
    | SaveClicked
    | GotSaveResponse (Listener.Response String ())



-------------------------------------------------------------------------------
-- INIT --
-------------------------------------------------------------------------------


init : Session -> Account -> Model
init session account =
    { session = session
    , account = account
    , tab = Account
    , nameField =
        account
            |> Account.getName
            |> Field.initWithValue
    , status = Ready
    }



-------------------------------------------------------------------------------
-- PUBLIC HELPERS --
-------------------------------------------------------------------------------


getSession : Model -> Session
getSession =
    .session


getAccount : Model -> Account
getAccount =
    .account


mapSession : (Session -> Session) -> Model -> Model
mapSession f model =
    { model | session = f model.session }



-------------------------------------------------------------------------------
-- PRIVATE HELPERS --
-------------------------------------------------------------------------------


tabToLabel : Tab -> String
tabToLabel tab =
    case tab of
        Account ->
            "account"

        KeyConfig ->
            "key config"


fail : Listener.Error String -> Model -> Model
fail error model =
    { model | status = Fail error }


becomeReady : Model -> Model
becomeReady model =
    { model | status = Ready }


saving : Model -> Model
saving model =
    { model | status = Saving }


setTab : Tab -> Model -> Model
setTab tab model =
    { model | tab = tab }


toAccount : Model -> Account
toAccount model =
    { email = model.account.email
    , name = Field.getValue model.nameField
    }


canTryToSave : Model -> Bool
canTryToSave model =
    Bool.Extra.all
        [ model.status == Ready

        -- has changes
        , toAccount model /= model.account
        , not (Field.hasError model.nameField)
        ]


setNameField : String -> Model -> Model
setNameField name model =
    { model
        | nameField =
            model.nameField
                |> Field.setValue name
                |> Field.clearError
    }


validate : Model -> Result Model { name : String }
validate model =
    let
        validatedModel : Model
        validatedModel =
            { model
                | nameField =
                    Field.validateIsNotBlank
                        { errorMessage = "you must have a user name" }
                        model.nameField
            }
    in
    if Field.getError validatedModel.nameField == Nothing then
        Ok { name = Field.getValue validatedModel.nameField }

    else
        Err validatedModel



-------------------------------------------------------------------------------
-- VIEW --
-------------------------------------------------------------------------------


view : Model -> Document Msg
view model =
    let
        navButton : Tab -> Html Msg
        navButton thisOption =
            Grid.row
                [ Style.marginBottom 2 ]
                [ Grid.column
                    []
                    [ Button.config
                        (TabClickedOn thisOption)
                        (tabToLabel thisOption)
                        |> Button.indent
                            (model.tab == thisOption)
                        |> Button.asFullWidth
                        |> Button.toHtml
                    ]
                ]
    in
    { title = Just "settings"
    , body =
        Body.view
            [ Grid.column
                [ Style.marginTop 3
                , Style.marginLeft 3
                , Grid.exactWidthColumn (Style.sizePx 7)
                , Css.flexDirection Css.column
                ]
                [ navButton Account
                , navButton KeyConfig
                ]
            , Grid.column
                [ Style.marginLeft 3
                , Style.paddingTop 3
                , Css.flexDirection Css.column
                ]
                (viewBody model)
            ]
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.status of
        Ready ->
            case model.tab of
                Account ->
                    accountView model

                KeyConfig ->
                    keyConfigView

        Saving ->
            [ Spinner.row ]

        Fail error ->
            [ Text.fromString
                """
                  Sorry, I wasnt able to update your user settings. Something
                  went wrong. If this problem persists please report this as
                  a bug.
                  """
            ]


keyConfigView : List (Html Msg)
keyConfigView =
    [ Text.fromString
        """
        Sorry, this feature is not yet implemented. If
        you would like a custom key config, you can request
        it on the road map page. I would appreciate the feedback.
        """
    ]


accountView : Model -> List (Html Msg)
accountView model =
    [ Grid.row
        [ Style.marginBottom 1 ]
        [ Grid.column
            []
            [ Text.fromString "user settings" ]
        ]
    , Grid.row
        []
        [ Grid.column
            []
            [ InputGroup.text
                { label = "name"
                , input =
                    Input.config
                        NameUpdated
                        (Field.getValue model.nameField)
                }
                |> InputGroup.withStyles [ Style.marginBottom 1 ]
                |> InputGroup.withError (Field.getError model.nameField)
                |> InputGroup.toHtml
            ]
        ]
    , Grid.row
        []
        [ Grid.column
            []
            [ Button.config
                SaveClicked
                "save"
                |> Button.isDisabled
                    (not <| canTryToSave model)
                |> Button.toHtml
            ]
        ]
    ]



-------------------------------------------------------------------------------
-- UPDATE --
-------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TabClickedOn tab ->
            setTab tab model
                |> CmdUtil.withNoCmd

        NameUpdated nameField ->
            setNameField nameField model
                |> CmdUtil.withNoCmd

        SaveClicked ->
            if canTryToSave model then
                case validate model of
                    Ok { name } ->
                        ( saving model
                        , Ports.payload "update user"
                            |> Ports.withString "email" model.account.email
                            |> Ports.withString "name" name
                            |> Ports.send
                        )

                    Err modelWithError ->
                        modelWithError
                            |> CmdUtil.withNoCmd

            else
                model
                    |> CmdUtil.withNoCmd

        GotSaveResponse response ->
            case response of
                Ok () ->
                    becomeReady model
                        |> CmdUtil.withNoCmd

                Err error ->
                    fail error model
                        |> CmdUtil.withNoCmd


track : Msg -> Maybe Tracking.Event
track msg =
    case msg of
        TabClickedOn tab ->
            Tracking.event "tab clicked"
                |> Tracking.withString "tab" (tabToLabel tab)

        NameUpdated _ ->
            Nothing

        SaveClicked ->
            Tracking.event "save clicked"

        GotSaveResponse response ->
            Tracking.event "got save response"
                |> Tracking.withListenerResponse response
