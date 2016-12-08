module Container.Messages exposing (..)

import Container.Models exposing (..)
import Tree.Models exposing (..)
import Header.Models exposing (..)
import Tree.Messages
import Header.Messages
import Content.Messages
import Http


type Msg
    = ShowContainer
    | OnAuthenticate (Result Http.Error AuthResult)
    | SelectPath NodeId
    | SelectTab TabType
    | TreeMsg Tree.Messages.Msg
    | HeaderMsg Header.Messages.Msg
    | ContentMsg Content.Messages.Msg
