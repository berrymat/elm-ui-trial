module Content.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field, at)
import Content.Messages exposing (..)
import Content.Models exposing (..)
import Header.Models exposing (..)
import Tree.Models exposing (..)
import Table
import Debug


fetchContent : String -> TabType -> NodeId -> Cmd Msg
fetchContent origin tabType nodeId =
    if nodeId /= "" then
        case tabType of
            FoldersType ->
                let
                    folderCmd =
                        fetchFolders origin nodeId

                    filesCmd =
                        fetchFiles origin nodeId
                in
                    Cmd.batch [ folderCmd, filesCmd ]

            UsersType ->
                fetchUsers origin nodeId

            CasesType ->
                fetchCases origin nodeId

            EmptyTab ->
                Cmd.none
    else
        Cmd.none


fetchFolders : String -> NodeId -> Cmd Msg
fetchFolders origin nodeId =
    Http.get (foldersUrl origin nodeId) foldersDecoder
        |> Http.send (OnFetchFolders nodeId)


fetchFiles : String -> NodeId -> Cmd Msg
fetchFiles origin nodeId =
    Http.get (filesUrl origin nodeId) filesDecoder
        |> Http.send (OnFetchFiles nodeId)


fetchUsers : String -> NodeId -> Cmd Msg
fetchUsers origin nodeId =
    Http.get (usersUrl origin nodeId) usersDecoder
        |> Http.send (OnFetchUsers nodeId)


fetchCases : String -> NodeId -> Cmd Msg
fetchCases origin nodeId =
    Http.get (casesUrl origin nodeId) casesDecoder
        |> Http.send (OnFetchCases nodeId)


apiUrl : String -> String
apiUrl origin =
    origin ++ "api/"


foldersUrl : String -> NodeId -> String
foldersUrl origin nodeId =
    (apiUrl origin) ++ "Folders/" ++ nodeId


filesUrl : String -> NodeId -> String
filesUrl origin nodeId =
    (apiUrl origin) ++ "Files/" ++ nodeId


usersUrl : String -> NodeId -> String
usersUrl origin nodeId =
    (apiUrl origin) ++ "Users/" ++ nodeId


casesUrl : String -> NodeId -> String
casesUrl origin nodeId =
    (apiUrl origin) ++ "Cases/" ++ nodeId



-- DECODERS


foldersDecoder : Decode.Decoder Folders
foldersDecoder =
    Decode.map4 createFolders
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "name" Decode.string)
        (field "children" (Decode.list (Decode.lazy (\_ -> folderDecoder))))


createFolders : NodeId -> String -> String -> List Node -> Folders
createFolders nodeId type_ name children =
    let
        tree =
            createTree
                nodeId
                type_
                name
                children
    in
        Folders
            tree
            True
            []
            ""
            []
            (Table.initialSort "Name")
            ""


folderDecoder : Decode.Decoder Node
folderDecoder =
    Decode.map4 createNode
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "name" Decode.string)
        (field "children" (Decode.list (Decode.lazy (\_ -> folderDecoder))))


childDecoder : Decode.Decoder Node
childDecoder =
    Decode.map3 createChild
        (field "id" Decode.string)
        (field "type" Decode.string)
        (field "name" Decode.string)


createTree : NodeId -> String -> String -> List Node -> Tree
createTree nodeId type_ name children =
    Tree
        nodeId
        (Maybe.withDefault FolderType (convertNodeType type_))
        name
        True
        Expanded
        (ChildNodes children)
        []


createNode : NodeId -> String -> String -> List Node -> Node
createNode nodeId type_ name children =
    Node
        nodeId
        (Maybe.withDefault FolderType (convertNodeType type_))
        name
        False
        (if (List.length children) == 0 then
            NoChildren
         else
            Expanded
        )
        (ChildNodes children)


createChild : NodeId -> String -> String -> Node
createChild nodeId type_ name =
    let
        a =
            Debug.log "nodeId" nodeId

        children =
            []
    in
        Node
            nodeId
            (Maybe.withDefault FolderType (convertNodeType type_))
            name
            False
            (if (List.length children) == 0 then
                NoChildren
             else
                Expanded
            )
            (ChildNodes children)


usersDecoder : Decode.Decoder Users
usersDecoder =
    Decode.map2 Users
        (field "id" Decode.string)
        (field "name" Decode.string)


casesDecoder : Decode.Decoder Cases
casesDecoder =
    Decode.map2 Cases
        (field "id" Decode.string)
        (field "name" Decode.string)


filesDecoder : Decode.Decoder (List File)
filesDecoder =
    Decode.map identity
        (field "files" (Decode.list fileDecoder))


fileDecoder : Decode.Decoder File
fileDecoder =
    Decode.map3 File
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "datetime" Decode.int)
