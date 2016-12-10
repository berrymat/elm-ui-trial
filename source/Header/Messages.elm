module Header.Messages exposing (..)

import Http
import Header.Models exposing (..)
import Tree.Models exposing (NodeId)
import Ui.DropdownMenu
import Ui.Modal


type Msg
    = OnFetchRoot NodeId (Result Http.Error HeaderInfo)
    | OnFetchCustomer NodeId (Result Http.Error HeaderInfo)
    | OnFetchClient NodeId (Result Http.Error HeaderInfo)
    | OnFetchSite NodeId (Result Http.Error HeaderInfo)
    | OnFetchStaff NodeId (Result Http.Error HeaderInfo)
    | ActionMenu Ui.DropdownMenu.Msg
    | CloseActionMenu
    | NoAction
    | EditModal Ui.Modal.Msg
    | OpenEditModal
    | CloseEditModal
    | DeleteModal Ui.Modal.Msg
    | OpenDeleteModal
    | CloseDeleteModal
