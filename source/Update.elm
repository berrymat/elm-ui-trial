module Update exposing (..)

import Ui.App
import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.Update
import Teams.Update
import Container.Update
import Routing exposing (Route(..), parseLocation)
import Players.Commands
import Teams.Commands
import Container.Commands
import Tree.Models exposing (convertNodeType)


fetchData : Model -> Cmd Msg
fetchData model =
    case model.route of
        PlayersRoute ->
            if List.isEmpty model.players then
                Cmd.map PlayersMsg Players.Commands.fetchAll
            else
                Cmd.none

        PlayerRoute id ->
            Cmd.none

        TeamsRoute ->
            if List.isEmpty model.teams then
                Cmd.map TeamsMsg Teams.Commands.fetchAll
            else
                Cmd.none

        TeamRoute id ->
            Cmd.none

        ContainerRoute type_ id ->
            let
                maybeNodeType =
                    convertNodeType type_
            in
                case maybeNodeType of
                    Just nodeType ->
                        Cmd.map ContainerMsg
                            (Container.Commands.authenticate
                                "berry.matthew@me.com"
                                "Cirrus8914!"
                                nodeType
                                id
                            )

                    Nothing ->
                        Cmd.none

        NotFoundRoute ->
            Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        App act ->
            let
                ( app, effect ) =
                    Ui.App.update act model.app
            in
                ( { model | app = app }, Cmd.map App effect )

        PlayersMsg subMsg ->
            let
                ( updatedPlayers, cmd ) =
                    Players.Update.update subMsg model.players
            in
                ( { model | players = updatedPlayers }, Cmd.map PlayersMsg cmd )

        TeamsMsg subMsg ->
            let
                ( updatedTeams, cmd ) =
                    Teams.Update.update subMsg model.teams
            in
                ( { model | teams = updatedTeams }, Cmd.map TeamsMsg cmd )

        ContainerMsg subMsg ->
            let
                ( updatedContainer, cmd ) =
                    Container.Update.update
                        subMsg
                        model.container
            in
                ( { model | container = updatedContainer }, Cmd.map ContainerMsg cmd )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                newModel =
                    { model | route = newRoute }
            in
                ( newModel, fetchData newModel )
