module Container.Messages exposing (..)

import Tree.Models exposing (..)
import Header.Models exposing (..)
import Tree.Messages
import Header.Messages
import Content.Messages


type Msg
    = ShowContainer
    | SelectPath NodeId
    | SelectTab TabType
    | TreeMsg Tree.Messages.Msg
    | HeaderMsg Header.Messages.Msg
    | ContentMsg Content.Messages.Msg
