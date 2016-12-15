module Container.Messages exposing (..)

import RemoteData exposing (..)
import Container.Models exposing (..)
import Tree.Models exposing (..)
import Helpers.Models exposing (..)
import Tree.Messages
import Header.Messages
import Content.Messages
import Http
import Customer.Header


type Msg
    = ShowContainer
    | OnAuthenticate (Result Http.Error AuthResult)
    | FetchInitialData NodeType NodeId
    | FetchHeader NodeType NodeId
    | RootResponse NodeId (WebData ContainerRoot)
    | CustomerResponse NodeId (WebData ContainerCustomer)
    | ClientResponse NodeId (WebData ContainerClient)
    | SiteResponse NodeId (WebData ContainerSite)
    | StaffResponse NodeId (WebData ContainerStaff)
    | SelectPath NodeId
    | SelectTab TabType
    | TreeMsg Tree.Messages.Msg
    | HeaderMsg Header.Messages.Msg
    | ContentMsg Content.Messages.Msg
    | CustomerMsg Customer.Header.Msg
