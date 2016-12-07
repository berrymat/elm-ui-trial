module Container.Commands exposing (..)

import Container.Messages exposing (..)
import Container.Models exposing (..)
import Tree.Models exposing (NodeId, NodeType, Node, ChildrenState(..))
import Header.Models exposing (Header(..))
import Tree.Commands
import Header.Commands


fetchAll : String -> NodeType -> NodeId -> Container -> Cmd Msg
fetchAll origin nodeType nodeId container =
    let
        treeCmd =
            if container.tree.childrenState == NoChildren then
                Cmd.map TreeMsg (Tree.Commands.fetchRoot origin nodeId)
            else
                Cmd.none

        headerCmd =
            if container.headerInfo.header == Empty then
                Cmd.map HeaderMsg (Header.Commands.fetchHeader origin nodeType nodeId)
            else
                Cmd.none
    in
        Cmd.batch [ treeCmd, headerCmd ]
