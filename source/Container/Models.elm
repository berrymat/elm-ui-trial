module Container.Models exposing (..)

import RemoteData exposing (..)
import Tree.Models exposing (Tree, initialTree, Node, NodeId, NodeType(..))
import Header.Models exposing (..)
import Helpers.Models exposing (..)
import Content.Models exposing (Content, initialContent)
import Customer.Header


type alias Container =
    { tree : Tree
    , root : WebData ContainerRoot
    , customer : WebData ContainerCustomer
    , client : WebData ContainerClient
    , site : WebData ContainerSite
    , staff : WebData ContainerStaff
    , customerHeader : Customer.Header.Model
    , tabs : WebData (List Tab)
    , path : List Node
    , headerType : NodeType
    , headerId : NodeId
    , tabType : TabType
    , content : Content
    }


initialContainer : Container
initialContainer =
    { tree = initialTree
    , root = NotAsked
    , customer = NotAsked
    , client = NotAsked
    , site = NotAsked
    , staff = NotAsked
    , customerHeader = Customer.Header.init
    , tabs = NotAsked
    , path = []
    , headerType = RootType
    , headerId = ""
    , tabType = FoldersType
    , content = initialContent
    }


type alias PathItem =
    { id : String
    , nodeType : NodeType
    , name : String
    }


type alias AuthResult =
    { nodeType : NodeType
    , nodeId : NodeId
    , result : String
    }


type alias ContainerRoot =
    { id : NodeId
    , access : RootAccess
    , values : RootValues
    , tabs : List Tab
    , useraccess : UserAccess
    }


type alias ContainerCustomer =
    { id : NodeId
    , access : CustomerAccess
    , values : CustomerValues
    , tabs : List Tab
    , useraccess : UserAccess
    }


type alias ContainerClient =
    { id : NodeId
    , access : ClientAccess
    , values : ClientValues
    , tabs : List Tab
    , useraccess : UserAccess
    }


type alias ContainerSite =
    { id : NodeId
    , access : SiteAccess
    , values : SiteValues
    , tabs : List Tab
    , useraccess : UserAccess
    }


type alias ContainerStaff =
    { id : NodeId
    , access : StaffAccess
    , values : StaffValues
    , tabs : List Tab
    , useraccess : UserAccess
    }
