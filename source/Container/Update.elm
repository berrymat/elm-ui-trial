module Container.Update exposing (..)

import Container.Messages exposing (Msg(..))
import Container.Models exposing (..)
import Container.Commands exposing (..)
import Tree.Commands
import Tree.Messages
import Tree.Models exposing (..)
import Tree.Update
import Header.Models exposing (..)
import Helpers.Models exposing (..)
import Header.Commands
import Header.Update
import Content.Commands
import Content.Update
import Navigation
import Customer.Header
import RemoteData exposing (..)
import Customer.Models exposing (CustomerData)


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
                    RemoteData.map convertCustomer response

                newTabs =
                    RemoteData.map (\r -> r.tabs) response

                ( newCustomerHeader, customerHeaderCmd ) =
                    Customer.Header.update (Customer.Header.CustomerResponse customerResponse) container.customerHeader

                ( contentCmd, newTabType ) =
                    case newTabs of
                        NotAsked ->
                            ( Cmd.none, container.tabType )

                        Loading ->
                            ( Cmd.none, container.tabType )

                        Failure err ->
                            ( Cmd.none, container.tabType )

                        Success tabs ->
                            let
                                maybeTab =
                                    List.filter (\t -> t.tabType == container.tabType) tabs
                                        |> List.head
                                        |> Debug.log "maybeTab"

                                defaultTabType =
                                    List.head tabs
                                        |> Maybe.map (\t -> t.tabType)
                                        |> Maybe.withDefault EmptyTab
                                        |> Debug.log "defaultTabType"

                                tabType =
                                    Maybe.map (\t -> t.tabType) maybeTab
                                        |> Maybe.withDefault defaultTabType
                                        |> Debug.log "tabType"

                                {-
                                   tabType =
                                       case maybeTab of
                                           Just tab ->
                                               tab.tabType

                                           Nothing ->
                                               let
                                                   maybeFirstTab =
                                                       List.head tabs
                                               in
                                                   case maybeFirstTab of
                                                       Just tab ->
                                                           tab.tabType

                                                       Nothing ->
                                                           EmptyTab
                                -}
                            in
                                ( (Content.Commands.fetchContent tabType container.headerId)
                                , tabType
                                )
            in
                ( { container
                    | customer = response
                    , customerHeader = newCustomerHeader
                    , tabs = newTabs
                    , tabType = newTabType
                  }
                , Cmd.batch
                    [ (Cmd.map CustomerMsg customerHeaderCmd)
                    , (Cmd.map ContentMsg contentCmd)
                    ]
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
                cmdContent =
                    Content.Commands.fetchContent tabType container.headerId
            in
                ( { container | tabType = tabType }, Cmd.map ContentMsg cmdContent )

        TreeMsg subMsg ->
            let
                ( updatedTree, cmdTree, path ) =
                    Tree.Update.update subMsg container.tree
            in
                updatePathFromTree container updatedTree cmdTree path

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
    Sub.none


convertCustomer : ContainerCustomer -> CustomerData
convertCustomer container =
    CustomerData container.id container.access container.values container.useraccess



{-
   Sub.batch
       [ Sub.map HeaderMsg (Header.Update.subscriptions container.headerInfo)
       ]
-}
