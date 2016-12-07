module Teams.Update exposing (..)

import Teams.Messages exposing (Msg(..))
import Teams.Models exposing (Team, TeamId)
import Teams.Commands exposing (save)
import Navigation


changeLevelCommands : TeamId -> Int -> List Team -> List (Cmd Msg)
changeLevelCommands teamId howMuch teams =
    let
        cmdForTeam existingTeam =
            if existingTeam.id == teamId then
                save { existingTeam | level = existingTeam.level + howMuch }
            else
                Cmd.none
    in
        List.map cmdForTeam teams


updateTeam : Team -> List Team -> List Team
updateTeam updatedTeam teams =
    let
        select existingTeam =
            if existingTeam.id == updatedTeam.id then
                updatedTeam
            else
                existingTeam
    in
        List.map select teams


update : Msg -> List Team -> ( List Team, Cmd Msg )
update message teams =
    case message of
        OnFetchAll (Ok newTeams) ->
            ( newTeams, Cmd.none )

        OnFetchAll (Err error) ->
            ( teams, Cmd.none )

        ShowTeams ->
            ( teams, Navigation.newUrl "#teams" )

        ShowTeam id ->
            ( teams, Navigation.newUrl ("#teams/" ++ id) )

        ChangeLevel id howMuch ->
            ( teams, changeLevelCommands id howMuch teams |> Cmd.batch )

        OnSave (Ok updatedTeam) ->
            ( updateTeam updatedTeam teams, Cmd.none )

        OnSave (Err error) ->
            ( teams, Cmd.none )
