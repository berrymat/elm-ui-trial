module Tree.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Tree.Messages exposing (..)
import Tree.Models exposing (..)


fetchRoot : String -> NodeId -> Cmd Msg
fetchRoot origin nodeId =
    Http.get (fetchNodeUrl origin nodeId) tempRootDecoder
        |> Http.send OnFetchRoot


fetchNode : String -> NodeId -> Cmd Msg
fetchNode origin nodeId =
    Http.get (fetchNodeUrl origin nodeId) tempChildrenDecoder
        |> Http.send (OnFetchNode nodeId)


fetchNodeUrl : String -> NodeId -> String
fetchNodeUrl origin nodeId =
    origin ++ "api/Node/" ++ nodeId



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
