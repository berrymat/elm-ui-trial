module Header.Messages exposing (..)

import Http
import Header.Models exposing (..)
import Tree.Models exposing (NodeId)
import Ui.DropdownMenu
import Ui.Modal


type Msg
    = OnFetchRoot NodeId (Result Http.Error HeaderData)
    | OnFetchCustomer NodeId (Result Http.Error HeaderData)
    | OnFetchClient NodeId (Result Http.Error HeaderData)
    | OnFetchSite NodeId (Result Http.Error HeaderData)
    | OnFetchStaff NodeId (Result Http.Error HeaderData)
    | ActionMenu Ui.DropdownMenu.Msg
    | CloseActionMenu
    | NoAction
    | EditModal Ui.Modal.Msg
    | OpenEditModal
    | CloseEditModal
    | DeleteModal Ui.Modal.Msg
    | OpenDeleteModal
    | CloseDeleteModal
