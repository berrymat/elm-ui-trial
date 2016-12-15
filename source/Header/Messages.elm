module Header.Messages exposing (..)

import Http
import Header.Models exposing (..)
import RemoteData exposing (..)
import Tree.Models exposing (NodeId, NodeType)
import Ui.DropdownMenu
import Ui.Modal


type Msg
    = FetchHeader NodeType NodeId
    | HeaderResponse (WebData HeaderData)
    | ActionMenu Ui.DropdownMenu.Msg
    | CloseActionMenu
    | NoAction
    | EditModal Ui.Modal.Msg
    | OpenEditModal
    | CloseEditModal
    | DeleteModal Ui.Modal.Msg
    | OpenDeleteModal
    | CloseDeleteModal
