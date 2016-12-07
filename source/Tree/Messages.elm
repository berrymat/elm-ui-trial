module Tree.Messages exposing (..)

import Http
import Tree.Models exposing (..)


type Msg
    = OnFetchRoot (Result Http.Error TempRoot)
    | OnFetchNode NodeId (Result Http.Error TempChildren)
    | ToggleNode String NodeId
    | SelectRoot
    | SelectNode NodeId
