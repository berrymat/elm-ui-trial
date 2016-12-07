module Container.Models exposing (..)

import Tree.Models exposing (Tree, initialTree, Node, NodeType)
import Header.Models exposing (HeaderInfo, initialHeaderInfo, Tab, TabType(..))
import Content.Models exposing (Content, initialContent)


type alias Container =
    { tree : Tree
    , path : List Node
    , headerInfo : HeaderInfo
    , tab : Tab
    , content : Content
    }


initialContainer : Container
initialContainer =
    { tree = initialTree
    , path = []
    , headerInfo = initialHeaderInfo
    , tab = Tab EmptyTab ""
    , content = initialContent
    }


type alias PathItem =
    { id : String
    , nodeType : NodeType
    , name : String
    }
