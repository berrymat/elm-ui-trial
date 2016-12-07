module Content.Messages exposing (..)

import Http
import Content.Models exposing (..)
import Tree.Models exposing (NodeId)
import Tree.Messages
import Table


type Msg
    = OnFetchFolders NodeId (Result Http.Error Folders)
    | OnFetchUsers NodeId (Result Http.Error Users)
    | OnFetchCases NodeId (Result Http.Error Cases)
    | TreeMsg Tree.Messages.Msg
    | OnFetchFiles NodeId (Result Http.Error (List File))
    | SetQuery String
    | SetTableState Table.State
