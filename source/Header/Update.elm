module Header.Update exposing (..)

import Header.Messages exposing (..)
import Header.Models exposing (..)
import Ui.DropdownMenu
import Ui.Modal


update : Msg -> HeaderInfo -> ( HeaderInfo, Cmd Msg )
update message headerInfo =
    case message of
        OnFetchRoot headerId (Ok newHeaderInfo) ->
            ( newHeaderInfo, Cmd.none )

        OnFetchRoot headerId (Err error) ->
            ( headerInfo, Cmd.none )

        OnFetchCustomer headerId (Ok newHeaderInfo) ->
            ( newHeaderInfo, Cmd.none )

        OnFetchCustomer headerId (Err error) ->
            ( headerInfo, Cmd.none )

        OnFetchClient headerId (Ok newHeaderInfo) ->
            ( newHeaderInfo, Cmd.none )

        OnFetchClient headerId (Err error) ->
            ( headerInfo, Cmd.none )

        OnFetchSite headerId (Ok newHeaderInfo) ->
            ( newHeaderInfo, Cmd.none )

        OnFetchSite headerId (Err error) ->
            ( headerInfo, Cmd.none )

        OnFetchStaff headerId (Ok newHeaderInfo) ->
            ( newHeaderInfo, Cmd.none )

        OnFetchStaff headerId (Err error) ->
            ( headerInfo, Cmd.none )

        DropdownMenu act ->
            let
                dropdownMenu =
                    Ui.DropdownMenu.update act headerInfo.dropdownMenu
            in
                ( { headerInfo | dropdownMenu = dropdownMenu }, Cmd.none )

        CloseMenu ->
            ( { headerInfo | dropdownMenu = Ui.DropdownMenu.close headerInfo.dropdownMenu }, Cmd.none )

        Header.Messages.Nothing ->
            ( headerInfo, Cmd.none )

        CloseModal ->
            ( { headerInfo
                | modal = Ui.Modal.close headerInfo.modal
                , dropdownMenu = Ui.DropdownMenu.close headerInfo.dropdownMenu
              }
            , Cmd.none
            )

        OpenModal ->
            ( { headerInfo
                | modal = Ui.Modal.open headerInfo.modal
                , dropdownMenu = Ui.DropdownMenu.close headerInfo.dropdownMenu
              }
            , Cmd.none
            )

        Modal act ->
            ( { headerInfo | modal = Ui.Modal.update act headerInfo.modal }, Cmd.none )


subscriptions : HeaderInfo -> Sub Msg
subscriptions headerInfo =
    Sub.batch
        [ Sub.map DropdownMenu (Ui.DropdownMenu.subscriptions headerInfo.dropdownMenu)
        ]
