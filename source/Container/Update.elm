module Container.Update exposing (..)

import Container.Messages exposing (Msg(..))
import Container.Models exposing (..)
import Container.Commands exposing (..)
import Tree.Messages
import Tree.Models exposing (..)
import Tree.Update
import Header.Models exposing (..)
import Header.Commands
import Header.Update
import Content.Commands
import Content.Update
import Navigation


updatePathFromTree : Container -> Tree -> Cmd Tree.Messages.Msg -> List Node -> ( Container, Cmd Msg )
updatePathFromTree container updatedTree cmdTree path =
    let
        maybeSelected =
            List.head path

        ( headerId, headerType ) =
            case maybeSelected of
                Just selected ->
                    ( selected.id, selected.nodeType )

                Nothing ->
                    ( container.tree.id, container.tree.nodeType )

        cmdHeader =
            if headerId /= (Header.Models.headerId container.headerInfo) then
                Header.Commands.fetchHeader headerType headerId
                    |> Cmd.map HeaderMsg
            else
                Cmd.none

        cmdBatch =
            Cmd.batch
                [ Cmd.map TreeMsg cmdTree
                , cmdHeader
                ]
    in
        ( { container | tree = updatedTree, path = path }, cmdBatch )


update : Msg -> Container -> ( Container, Cmd Msg )
update message container =
    case message of
        ShowContainer ->
            ( container
            , Navigation.newUrl "#container/customer/path/Customer-46-Client"
            )

        OnAuthenticate (Ok result) ->
            if result.result == "OK" then
                ( container, fetchInitialData result.nodeType result.nodeId container )
            else
                ( container, Cmd.none )

        OnAuthenticate (Err error) ->
            ( container, Cmd.none )

        SelectPath nodeId ->
            let
                ( updatedTree, cmdTree, path ) =
                    Tree.Update.update (Tree.Messages.SelectNode nodeId) container.tree
            in
                updatePathFromTree container updatedTree cmdTree path

        SelectTab tabType ->
            let
                nodeId =
                    Header.Models.headerId container.headerInfo

                updatedTab =
                    getTabFromType container.headerInfo tabType

                cmdContent =
                    Content.Commands.fetchContent tabType nodeId
            in
                ( { container | tab = updatedTab }, Cmd.map ContentMsg cmdContent )

        TreeMsg subMsg ->
            let
                ( updatedTree, cmdTree, path ) =
                    Tree.Update.update subMsg container.tree
            in
                updatePathFromTree container updatedTree cmdTree path

        HeaderMsg subMsg ->
            let
                ( updatedHeaderInfo, cmdHeader ) =
                    Header.Update.update subMsg container.headerInfo

                headerId =
                    Header.Models.headerId container.headerInfo

                updatedHeaderId =
                    Header.Models.headerId updatedHeaderInfo

                updatedTab =
                    getTabFromType updatedHeaderInfo container.tab.tabType

                cmdContent =
                    if (headerId /= updatedHeaderId) then
                        Content.Commands.fetchContent updatedTab.tabType updatedHeaderId
                    else
                        Cmd.none

                cmdBatch =
                    Cmd.batch
                        [ Cmd.map HeaderMsg cmdHeader
                        , Cmd.map ContentMsg cmdContent
                        ]
            in
                ( { container | headerInfo = updatedHeaderInfo, tab = updatedTab }, cmdBatch )

        ContentMsg subMsg ->
            let
                ( updatedContent, cmdContent ) =
                    Content.Update.update subMsg container.content
            in
                ( { container | content = updatedContent }, Cmd.map ContentMsg cmdContent )


subscriptions : Container -> Sub Msg
subscriptions container =
    Sub.batch
        [ Sub.map HeaderMsg (Header.Update.subscriptions container.headerInfo)
        ]
