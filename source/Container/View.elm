module Container.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, style, attribute, href, id, classList, src)
import Html.Events exposing (onClick)
import Container.Messages exposing (..)
import Container.Models exposing (..)
import Header.Models exposing (..)
import Tree.View
import Header.View
import Content.View


view : String -> Container -> Html Msg
view origin container =
    div [ class "fullview" ]
        [ div [ class "sidebar" ]
            [ Html.map
                TreeMsg
                (Tree.View.view origin container.tree)
            ]
        , div [ class "body" ]
            [ Html.map
                HeaderMsg
                (Header.View.view container.headerInfo)
            , div [ class "body-path" ]
                [ viewPath container
                , viewTabs container
                ]
            , Html.map
                ContentMsg
                (Content.View.view origin container.content)
            ]
        ]


clickablePathItem : PathItem -> Html Msg
clickablePathItem item =
    div []
        [ div
            [ class "path-item clickable"
            , onClick (SelectPath item.id)
            ]
            [ text item.name ]
        , i [ class "fa fa-chevron-right" ] []
        ]


lastPathItem : PathItem -> Html Msg
lastPathItem item =
    div [ class "path-item" ]
        [ text item.name ]


viewPath : Container -> Html Msg
viewPath container =
    let
        tree =
            container.tree

        rootItem =
            { id = tree.id, nodeType = tree.nodeType, name = tree.name }

        ( items, last ) =
            case container.path of
                [] ->
                    ( [], rootItem )

                head :: rest ->
                    let
                        pathItems =
                            rest
                                |> List.reverse
                                |> List.map (\n -> { id = n.id, nodeType = n.nodeType, name = n.name })
                    in
                        ( rootItem :: pathItems, { id = head.id, nodeType = head.nodeType, name = head.name } )
    in
        div [ class "breadcrumb" ]
            [ div []
                (List.map clickablePathItem items)
            , lastPathItem last
            ]


viewTabs : Container -> Html Msg
viewTabs container =
    div [ class "tabs" ]
        (List.map (tabItem container.tab) container.headerInfo.tabs)


tabItem : Tab -> Tab -> Html Msg
tabItem selected tab =
    div
        [ classList
            [ ( "tab", True )
            , ( "active", selected.tabType == tab.tabType )
            , ( "clickable", selected.tabType /= tab.tabType )
            ]
        , onClick (SelectTab tab.tabType)
        ]
        [ text tab.name ]
