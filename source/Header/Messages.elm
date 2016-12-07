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
    | DropdownMenu Ui.DropdownMenu.Msg
    | CloseMenu
    | Nothing
    | Modal Ui.Modal.Msg
    | OpenModal
    | CloseModal
