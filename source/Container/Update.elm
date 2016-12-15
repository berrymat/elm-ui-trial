module Container.Update exposing (..)

import Container.Messages exposing (Msg(..))
import Container.Models exposing (..)
import Container.Commands exposing (..)
import Tree.Commands
import Tree.Messages
import Tree.Models exposing (..)
import Tree.Update
import Header.Models exposing (..)
import Header.Commands
import Header.Update
import Content.Commands
import Content.Update
import Navigation
import Customer.Header
import RemoteData exposing (..)


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
                    ( updatedTree.id, updatedTree.nodeType )

        treeContainer =
            { container | tree = updatedTree, path = path }

        ( headerContainer, cmd ) =
            if (headerType /= container.headerType) || (headerId /= container.headerId) then
                update (FetchHeader headerType headerId) treeContainer
            else
                ( treeContainer, Cmd.none )

        cmdBatch =
            Cmd.batch
                [ Cmd.map TreeMsg cmdTree
                , cmd
                ]
    in
        ( headerContainer, cmdBatch )


update : Msg -> Container -> ( Container, Cmd Msg )
update message container =
    case message of
        ShowContainer ->
            ( container
            , Navigation.newUrl "#container/customer/path/Customer-46-Client"
            )

        OnAuthenticate (Ok result) ->
            if result.result == "OK" then
                update (FetchInitialData result.nodeType result.nodeId) container
            else
                ( container, Cmd.none )

        OnAuthenticate (Err error) ->
            ( container, Cmd.none )

        FetchInitialData nodeType nodeId ->
            let
                treeCmd =
                    Cmd.map TreeMsg (Tree.Commands.fetchRoot nodeId)

                ( newContainer, cmd ) =
                    update (FetchHeader nodeType nodeId) container
            in
                ( newContainer, Cmd.batch [ treeCmd, cmd ] )

        FetchHeader nodeType nodeId ->
            let
                newContainer =
                    { container | headerType = nodeType, headerId = nodeId }
            in
                case nodeType of
                    RootType ->
                        ( { newContainer | root = Loading }, fetchRoot nodeId )

                    CustomerType ->
                        ( { newContainer | customer = Loading }, fetchCustomer nodeId )

                    ClientType ->
                        ( { newContainer | client = Loading }, fetchClient nodeId )

                    SiteType ->
                        ( { newContainer | site = Loading }, fetchSite nodeId )

                    StaffType ->
                        ( { newContainer | staff = Loading }, fetchStaff nodeId )

                    FolderType ->
                        ( newContainer, Cmd.none )

        RootResponse nodeId response ->
            ( { container | root = response }
            , Cmd.none
            )

        CustomerResponse nodeId response ->
            let
                customerResponse =
                    RemoteData.map
                        (\r ->
                            { id = r.id
                            , access = r.access
                            , values = r.values
                            , useraccess = r.useraccess
                            }
                        )
                        response

                newTabs =
                    RemoteData.map (\r -> r.tabs) response

                ( newCustomerHeader, customerHeaderCmd ) =
                    Customer.Header.update (Customer.Header.CustomerResponse customerResponse) container.customerHeader
            in
                ( { container | customer = response, customerHeader = newCustomerHeader, tabs = newTabs }
                , (Cmd.map CustomerMsg customerHeaderCmd)
                )

        ClientResponse nodeId response ->
            ( { container | client = response }
            , Cmd.none
            )

        SiteResponse nodeId response ->
            ( { container | site = response }
            , Cmd.none
            )

        StaffResponse nodeId response ->
            ( { container | staff = response }
            , Cmd.none
            )

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

        CustomerMsg subMsg ->
            let
                ( updatedCustomer, cmdCustomer ) =
                    Customer.Header.update subMsg container.customerHeader
            in
                ( { container | customerHeader = updatedCustomer }, Cmd.map CustomerMsg cmdCustomer )


subscriptions : Container -> Sub Msg
subscriptions container =
    Sub.batch
        [ Sub.map HeaderMsg (Header.Update.subscriptions container.headerInfo)
        ]
