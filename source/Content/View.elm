module Content.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Content.Messages exposing (..)
import Content.Models exposing (..)
import Tree.View
import Table


view : String -> Content -> Html Msg
view origin content =
    case content of
        FoldersContent folders ->
            contentFolders origin folders

        UsersContent users ->
            contentUsers users

        CasesContent cases ->
            contentCases cases

        EmptyContent ->
            contentEmpty


contentFolders : String -> Folders -> Html Msg
contentFolders origin folders =
    div [ class "body-content" ]
        [ div [ class "body-content-sidebar" ]
            [ Html.map
                TreeMsg
                (Tree.View.view origin folders.tree)
            ]
        , div [ class "body-content-content" ]
            [ contentFiles folders ]
        ]


contentFiles : Folders -> Html Msg
contentFiles folders =
    let
        lowerQuery =
            String.toLower folders.query

        acceptableFiles =
            List.filter (String.contains lowerQuery << String.toLower << .name) folders.files
    in
        div []
            [ h1 [] [ text "Files" ]
            , input [ placeholder "Search by Name", onInput SetQuery ] []
            , Table.view config folders.tableState acceptableFiles
            ]


config : Table.Config File Msg
config =
    Table.config
        { toId = .name
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Name" .name
            , Table.intColumn "DateTime" .datetime
            ]
        }


contentUsers : Users -> Html Msg
contentUsers users =
    div [ class "body-content" ]
        [ div [ class "body-content-content" ]
            [ text "Users" ]
        ]


contentCases : Cases -> Html Msg
contentCases cases =
    div [ class "body-content" ]
        [ div [ class "body-content-content" ]
            [ text "Cases" ]
        ]


contentEmpty : Html Msg
contentEmpty =
    div [ class "body-content" ]
        [ div [ class "body-content-content" ]
            [ text "Empty" ]
        ]
