module Reply
    exposing
        ( Reply(..)
        , noReply
        , nothing
        )

import Data.User exposing (User)


type Reply
    = NoReply
    | SetUser User


nothing : model -> ( model, Cmd msg, Reply )
nothing model =
    ( model, Cmd.none, NoReply )


noReply : ( model, Cmd msg ) -> ( model, Cmd msg, Reply )
noReply ( model, cmd ) =
    ( model, cmd, NoReply )
