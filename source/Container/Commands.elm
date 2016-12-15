module Container.Commands exposing (..)

import Container.Messages exposing (..)
import Container.Models exposing (..)
import Tree.Models exposing (NodeId, NodeType, Node, ChildrenState(..))
import Header.Models exposing (isHeaderEmpty)
import Tree.Commands
import Header.Commands
import Helpers.Helpers exposing (apiUrl)
import Erl
import Http
import Json.Decode as Decode exposing (field)
import HttpBuilder exposing (..)


{-
   authenticate : String -> String -> NodeType -> NodeId -> Cmd Msg
   authenticate username password nodeType nodeId =
       Http.get (authenticateUrl username password) (authenticateDecoder nodeType nodeId)
           |> Http.send OnAuthenticate
-}


authenticate : String -> String -> NodeType -> NodeId -> Cmd Msg
authenticate username password nodeType nodeId =
    HttpBuilder.get (authenticateUrl username password)
        |> withExpect (Http.expectJson (authenticateDecoder nodeType nodeId))
        |> withCredentials
        |> send OnAuthenticate


authenticateUrl : String -> String -> String
authenticateUrl username password =
    let
        erl =
            Erl.parse (apiUrl ++ "Login")
                |> Erl.addQuery "username" username
                |> Erl.addQuery "password" password
    in
        Erl.toString erl


authenticateDecoder : NodeType -> NodeId -> Decode.Decoder AuthResult
authenticateDecoder nodeType nodeId =
    Decode.map (AuthResult nodeType nodeId)
        Decode.string


fetchInitialData : NodeType -> NodeId -> Container -> Cmd Msg
fetchInitialData nodeType nodeId container =
    let
        treeCmd =
            if container.tree.childrenState == NoChildren then
                Cmd.map TreeMsg (Tree.Commands.fetchRoot nodeId)
            else
                Cmd.none

        headerCmd =
            if (isHeaderEmpty container.headerInfo) then
                Cmd.map HeaderMsg (Header.Commands.fetchHeader nodeType nodeId)
            else
                Cmd.none
    in
        Cmd.batch [ treeCmd, headerCmd ]
