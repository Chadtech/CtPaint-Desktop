module Util.Cmd exposing
    ( addCmd
    , justModel
    , mapCmd
    , mapModel
    , withCmd
    , withCmds
    , withModel
    , withNoCmd
    )


mapCmd : (a -> b) -> ( model, Cmd a ) -> ( model, Cmd b )
mapCmd f ( model, cmd ) =
    ( model, Cmd.map f cmd )


withCmds : List (Cmd msg) -> model -> ( model, Cmd msg )
withCmds cmds model =
    ( model, Cmd.batch cmds )


withCmd : Cmd msg -> model -> ( model, Cmd msg )
withCmd cmd model =
    ( model, cmd )


withNoCmd : model -> ( model, Cmd msg )
withNoCmd model =
    ( model, Cmd.none )


withModel : model -> Cmd msg -> ( model, Cmd msg )
withModel =
    Tuple.pair


mapModel : (a -> b) -> ( a, Cmd msg ) -> ( b, Cmd msg )
mapModel =
    Tuple.mapFirst


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd extra ( model, cmd ) =
    ( model, Cmd.batch [ extra, cmd ] )


justModel : model -> ( model, Cmd msg, Maybe effect )
justModel model =
    ( model, Cmd.none, Nothing )
