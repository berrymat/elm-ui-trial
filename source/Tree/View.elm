module Tree.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute, href, id, classList)
import Html.Events exposing (onClick)
import Tree.Messages exposing (..)
import Tree.Models exposing (..)


view : Tree -> Html Msg
view tree =
    div []
        [ viewTree tree
        ]


viewTree : Tree -> Html Msg
viewTree tree =
    div [ class "k-treeview" ]
        [ ul [ class "k-group", attribute "role" "group", attribute "style" "display: block;" ]
            [ viewRoot tree ]
        ]


viewRoot : Tree -> Html Msg
viewRoot tree =
    let
        childStyle =
            if tree.childrenState == Expanded then
                "display: block;"
            else
                "display: none; overflow: visible; height: 0px;"

        expandedValue =
            if tree.childrenState == Expanded then
                "true"
            else
                "false"

        ( iconClass, faClass ) =
            case tree.childrenState of
                Collapsed ->
                    ( "k-icon k-plus", "fa fa-caret-right" )

                Expanding ->
                    ( "k-icon k-minus", "fa fa-spin fa-refresh" )

                Expanded ->
                    ( "k-icon k-minus", "fa fa-caret-down" )

                NoChildren ->
                    ( "", "" )

        nodeStyle =
            "k-in btn regular p0"
                ++ if tree.selected then
                    " k-state-selected"
                   else
                    ""

        (Tree.Models.ChildNodes childNodes) =
            tree.childNodes
    in
        li
            [ class "k-item"
            , attribute "aria-expanded" expandedValue
            , attribute "data-expanded" expandedValue
            , attribute "role" "treeitem"
            ]
            [ div [ class "k-mid" ]
                [ span
                    [ class iconClass
                    , attribute "role" "presentation"
                    , onClick (ToggleNode tree.id)
                    ]
                    [ i
                        [ class faClass
                        ]
                        []
                    ]
                , div
                    [ class nodeStyle
                    , onClick SelectRoot
                    ]
                    [ text tree.name ]
                ]
            , ul [ class "k-group", attribute "role" "group", attribute "style" childStyle ]
                (List.map viewNode childNodes)
            ]


viewNode : Node -> Html Msg
viewNode node =
    let
        childStyle =
            if node.childrenState == Expanded then
                "display: block;"
            else
                "display: none; overflow: visible; height: 0px;"

        expandedValue =
            if node.childrenState == Expanded then
                "true"
            else
                "false"

        ( iconClass, faClass ) =
            case node.childrenState of
                Collapsed ->
                    ( "k-icon k-plus", "fa fa-caret-right" )

                Expanding ->
                    ( "k-icon k-minus", "fa fa-spin fa-refresh" )

                Expanded ->
                    ( "k-icon k-minus", "fa fa-caret-down" )

                NoChildren ->
                    ( "", "" )

        nodeStyle =
            "k-in btn regular p0"
                ++ if node.selected then
                    " k-state-selected"
                   else
                    ""

        (Tree.Models.ChildNodes childNodes) =
            node.childNodes
    in
        li
            [ class "k-item"
            , attribute "aria-expanded" expandedValue
            , attribute "data-expanded" expandedValue
            , attribute "role" "treeitem"
            ]
            [ div [ class "k-mid" ]
                [ span
                    [ class iconClass
                    , attribute "role" "presentation"
                    , onClick (ToggleNode node.id)
                    ]
                    [ i
                        [ class faClass
                        ]
                        []
                    ]
                , div
                    [ class nodeStyle
                    , onClick (SelectNode node.id)
                    ]
                    [ text node.name ]
                ]
            , ul [ class "k-group", attribute "role" "group", attribute "style" childStyle ]
                (List.map viewNode childNodes)
            ]
