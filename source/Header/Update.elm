module Header.Update exposing (..)

import Header.Messages exposing (..)
import Header.Models exposing (..)
import Ui.DropdownMenu
import Ui.Modal


update : Msg -> HeaderInfo -> ( HeaderInfo, Cmd Msg )
update message headerInfo =
    let
        ui =
            headerInfo.ui
    in
        case message of
            OnFetchRoot headerId (Ok newHeaderData) ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

            OnFetchRoot headerId (Err error) ->
                ( headerInfo, Cmd.none )

            OnFetchCustomer headerId (Ok newHeaderData) ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

            OnFetchCustomer headerId (Err error) ->
                ( headerInfo, Cmd.none )

            OnFetchClient headerId (Ok newHeaderData) ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

            OnFetchClient headerId (Err error) ->
                ( headerInfo, Cmd.none )

            OnFetchSite headerId (Ok newHeaderData) ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

            OnFetchSite headerId (Err error) ->
                ( headerInfo, Cmd.none )

            OnFetchStaff headerId (Ok newHeaderData) ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

            OnFetchStaff headerId (Err error) ->
                ( headerInfo, Cmd.none )

            ActionMenu action ->
                let
                    newActionMenu =
                        Ui.DropdownMenu.update action ui.actionMenu

                    newUi =
                        { ui | actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            CloseActionMenu ->
                let
                    newActionMenu =
                        Ui.DropdownMenu.close ui.actionMenu

                    newUi =
                        { ui | actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            NoAction ->
                ( headerInfo, Cmd.none )

            CloseEditModal ->
                let
                    newEditModal =
                        Ui.Modal.close ui.editModal

                    newActionMenu =
                        Ui.DropdownMenu.close ui.actionMenu

                    newUi =
                        { ui | editModal = newEditModal, actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            OpenEditModal ->
                let
                    newEditModal =
                        Ui.Modal.open ui.editModal

                    newActionMenu =
                        Ui.DropdownMenu.close ui.actionMenu

                    newUi =
                        { ui | editModal = newEditModal, actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            EditModal action ->
                let
                    newEditModal =
                        Ui.Modal.update action ui.editModal

                    newUi =
                        { ui | editModal = newEditModal }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            CloseDeleteModal ->
                let
                    newDeleteModal =
                        Ui.Modal.close ui.deleteModal

                    newActionMenu =
                        Ui.DropdownMenu.close ui.actionMenu

                    newUi =
                        { ui | deleteModal = newDeleteModal, actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            OpenDeleteModal ->
                let
                    newDeleteModal =
                        Ui.Modal.open ui.deleteModal

                    newActionMenu =
                        Ui.DropdownMenu.close ui.actionMenu

                    newUi =
                        { ui | deleteModal = newDeleteModal, actionMenu = newActionMenu }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )

            DeleteModal action ->
                let
                    newDeleteModal =
                        Ui.Modal.update action ui.deleteModal

                    newUi =
                        { ui | deleteModal = newDeleteModal }
                in
                    ( { headerInfo | ui = newUi }, Cmd.none )


subscriptions : HeaderInfo -> Sub Msg
subscriptions headerInfo =
    Sub.batch
        [ Sub.map ActionMenu (Ui.DropdownMenu.subscriptions headerInfo.ui.actionMenu)
        ]
