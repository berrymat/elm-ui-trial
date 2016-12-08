module Tree.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Tree.Messages exposing (..)
import Tree.Models exposing (..)
import Helpers.Helpers exposing (apiUrl, fetcher)


fetchRoot : NodeId -> Cmd Msg
fetchRoot nodeId =
    fetcher (fetchNodeUrl nodeId) tempRootDecoder OnFetchRoot


fetchNode : NodeId -> Cmd Msg
fetchNode nodeId =
    fetcher (fetchNodeUrl nodeId) tempChildrenDecoder (OnFetchNode nodeId)


fetchNodeUrl : NodeId -> String
fetchNodeUrl nodeId =
    apiUrl ++ "Node/" ++ nodeId



-- DECODERS


tempNodeDecoder : Decode.Decoder TempNode
tempNodeDecoder =
    Decode.map4 TempNode
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "name" Decode.string)
        (field "hasChildren" Decode.bool)


tempRootDecoder : Decode.Decoder TempRoot
tempRootDecoder =
    Decode.map4 TempRoot
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "name" Decode.string)
        (field "children" (Decode.list tempNodeDecoder))


tempChildrenDecoder : Decode.Decoder TempChildren
tempChildrenDecoder =
    Decode.map3 TempChildren
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "children" (Decode.list tempNodeDecoder))
