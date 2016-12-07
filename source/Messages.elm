module Messages exposing (..)

import Ui.App
import Navigation exposing (Location)
import Players.Messages
import Teams.Messages
import Container.Messages


type Msg
    = App Ui.App.Msg
    | PlayersMsg Players.Messages.Msg
    | TeamsMsg Teams.Messages.Msg
    | ContainerMsg Container.Messages.Msg
    | OnLocationChange Location
