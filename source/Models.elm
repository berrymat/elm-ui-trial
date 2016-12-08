module Models exposing (..)

import Ui.App
import Players.Models exposing (Player)
import Teams.Models exposing (Team)
import Container.Models exposing (Container, initialContainer)
import Routing


type alias Model =
    { app : Ui.App.Model
    , players : List Player
    , teams : List Team
    , container : Container
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { app = Ui.App.init
    , players = []
    , teams = []
    , container = initialContainer
    , route = route
    }
