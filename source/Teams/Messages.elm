module Teams.Messages exposing (..)

import Http
import Teams.Models exposing (TeamId, Team)


type Msg
    = OnFetchAll (Result Http.Error (List Team))
    | ShowTeams
    | ShowTeam TeamId
    | ChangeLevel TeamId Int
    | OnSave (Result Http.Error Team)
