module Reply exposing (Reply(..))

import Data.User exposing (User)


type Reply
    = NoReply
    | SetUser User
