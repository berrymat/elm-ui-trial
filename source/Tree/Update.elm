module Tree.Update exposing (..)

import Tree.Messages exposing (Msg(..))
import Tree.Models exposing (..)
import Tree.Commands


selectNode : NodeId -> Node -> ( Node, List Node )
selectNode nodeId node =
    let
        (ChildNodes childNodes) =
            node.childNodes

        results =
            List.map (selectNode nodeId) childNodes

        ( newChildNodes, newPathLists ) =
            List.unzip results

        newNode =
            { node | childNodes = ChildNodes newChildNodes, selected = node.id == nodeId }

        newPath =
            if newNode.selected then
                [ newNode ]
            else
                let
                    concatLists =
                        List.concat newPathLists
                in
                    if List.isEmpty concatLists then
                        concatLists
                    else
                        List.append concatLists [ newNode ]
    in
        ( newNode, newPath )


select : NodeId -> Tree -> Tree
select nodeId tree =
    let
        (ChildNodes childNodes) =
            tree.childNodes

        results =
            List.map (selectNode nodeId) childNodes

        ( newChildren, newPathLists ) =
            List.unzip results

        newPath =
            List.concat newPathLists

        newSelected =
            (List.length newPath) == 0
    in
        { tree | childNodes = (ChildNodes newChildren), selected = newSelected, path = newPath }


toggleChildNodes : String -> NodeId -> Node -> ( Node, Cmd Msg )
toggleChildNodes origin nodeId node =
    let
        (ChildNodes childNodes) =
            node.childNodes

        results =
            List.map (toggleNode origin nodeId) childNodes

        ( newChildNodes, cmds ) =
            List.unzip results
    in
        ( { node | childNodes = ChildNodes newChildNodes }, Cmd.batch cmds )


toggleNode : String -> NodeId -> Node -> ( Node, Cmd Msg )
toggleNode origin nodeId node =
    let
        ( newNode, cmd ) =
            if nodeId == node.id then
                case node.childrenState of
                    NoChildren ->
                        ( node, Cmd.none )

                    Collapsed ->
                        let
                            (ChildNodes childNodes) =
                                node.childNodes
                        in
                            if List.isEmpty childNodes then
                                ( { node | childrenState = Expanding }, Tree.Commands.fetchNode origin node.id )
                            else
                                ( { node | childrenState = Expanded }, Cmd.none )

                    Expanding ->
                        ( node, Cmd.none )

                    Expanded ->
                        ( { node | childrenState = Collapsed }, Cmd.none )
            else
                toggleChildNodes origin nodeId node
    in
        ( newNode, cmd )


toggle : String -> NodeId -> Tree -> ( Tree, Cmd Msg )
toggle origin nodeId tree =
    let
        (ChildNodes childNodes) =
            tree.childNodes

        results =
            List.map (toggleNode origin nodeId) childNodes

        ( newChildren, cmds ) =
            List.unzip results
    in
        ( { tree | childNodes = (ChildNodes newChildren) }, Cmd.batch cmds )


createNode : TempNode -> Node
createNode tempNode =
    let
        nodeType =
            Maybe.withDefault RootType (convertNodeType tempNode.type_)
    in
        { id = tempNode.id
        , nodeType = nodeType
        , name = tempNode.name
        , selected = False
        , childrenState =
            if tempNode.hasChildren then
                Collapsed
            else
                NoChildren
        , childNodes = ChildNodes []
        }


fetchedRoot : TempRoot -> Tree
fetchedRoot tempRoot =
    let
        nodeType =
            Maybe.withDefault RootType (convertNodeType tempRoot.type_)
    in
        { id = tempRoot.id
        , nodeType = nodeType
        , name = tempRoot.name
        , selected = True
        , childrenState = Expanded
        , childNodes = (ChildNodes (List.map createNode tempRoot.children))
        , path = []
        }


convertChildren : TempChildren -> List Node
convertChildren tempChildren =
    List.map createNode tempChildren.children


expandChildren : NodeId -> TempChildren -> Node -> Node
expandChildren nodeId tempChildren node =
    if nodeId == node.id then
        { node | childrenState = Expanded, childNodes = ChildNodes (convertChildren tempChildren) }
    else
        let
            (ChildNodes childNodes) =
                node.childNodes

            newChildNodes =
                List.map (expandChildren nodeId tempChildren) childNodes
        in
            { node | childNodes = ChildNodes newChildNodes }


fetchedNode : NodeId -> TempChildren -> Tree -> Tree
fetchedNode nodeId tempChildren tree =
    let
        (ChildNodes childNodes) =
            tree.childNodes

        newChildren =
            List.map (expandChildren nodeId tempChildren) childNodes
    in
        { tree | childNodes = (ChildNodes newChildren) }


update : Msg -> Tree -> ( Tree, Cmd Msg, List Node )
update message tree =
    case message of
        OnFetchRoot (Ok tempChildren) ->
            ( fetchedRoot tempChildren, Cmd.none, tree.path )

        OnFetchRoot (Err error) ->
            ( tree, Cmd.none, tree.path )

        OnFetchNode nodeId (Ok tempChildren) ->
            ( fetchedNode nodeId tempChildren tree, Cmd.none, tree.path )

        OnFetchNode nodeId (Err error) ->
            ( tree, Cmd.none, tree.path )

        ToggleNode origin nodeId ->
            let
                ( newTree, cmds ) =
                    toggle origin nodeId tree
            in
                ( newTree, cmds, tree.path )

        SelectRoot ->
            let
                newTree =
                    select tree.id tree
            in
                ( newTree, Cmd.none, newTree.path )

        SelectNode nodeId ->
            let
                newTree =
                    select nodeId tree
            in
                ( newTree, Cmd.none, newTree.path )
