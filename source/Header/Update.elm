module Header.Update exposing (..)

import Header.Messages exposing (..)
import Header.Commands exposing (..)
import Header.Models exposing (..)
import Ui.DropdownMenu
import Ui.Modal
import RemoteData exposing (..)


update : Msg -> HeaderInfo -> ( HeaderInfo, Cmd Msg )
update message headerInfo =
    let
        ui =
            headerInfo.ui
    in
        case message of
            FetchHeader nodeType nodeId ->
                let
                    cmd =
                        fetchHeader nodeType nodeId
                in
                    ( { headerInfo | data = Loading }, cmd )

            HeaderResponse newHeaderData ->
                ( { headerInfo | data = newHeaderData }, Cmd.none )

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
