module Header.Site.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Header.Messages exposing (..)
import Header.Models exposing (..)
import Header.Utils exposing (..)
import Helpers.Helpers exposing (..)
import Ui
import Ui.Button
import Ui.Container
import Ui.DropdownMenu
import Ui.IconButton
import Ui.Modal


actionDropdownViewModel : Ui.DropdownMenu.ViewModel Msg
actionDropdownViewModel =
    { element =
        Ui.IconButton.secondary "Actions"
            "chevron-down"
            "right"
            NoAction
    , items =
        [ Ui.DropdownMenu.item [ onClick OpenEditModal ]
            [ Ui.icon "android-download" True []
            , node "span" [] [ text "Edit" ]
            ]
        , Ui.DropdownMenu.item [ onClick OpenDeleteModal ]
            [ Ui.icon "trash-b" True []
            , node "span" [] [ text "Delete" ]
            ]
        ]
    }


headerItems : Site -> List (Html Msg)
headerItems site =
    let
        access =
            site.access

        values =
            site.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode
    in
        [ headerItem "Ref" "wrench" access.name values.no
        , headerItem "Name" "globe" access.name values.name
        , headerItem "Address" "home" access.address address
        , headerItem "Contact" "user-o" access.contact values.contact
        , headerItem "Phone" "phone" access.contact values.tel
        , headerItem "Email" "envelope" access.contact values.email
        , headerItem "Division Mgr" "user-o" access.managers values.divisionMgr
        , headerItem "Area Mgr" "user-o" access.managers values.areaMgr
        , headerItem "Supervisor" "user-o" access.managers values.supervisor
        ]


headerActions : Site -> UserAccess -> HeaderUi -> List (Html Msg)
headerActions site useraccess ui =
    let
        editModalViewModel =
            { content = [ text "Edit Modal" ]
            , title = "Edit Details"
            , footer =
                [ Ui.Container.rowEnd []
                    [ Ui.Button.primary "Save" CloseEditModal
                    , Ui.Button.secondary "Close" CloseEditModal
                    ]
                ]
            }

        deleteModalViewModel =
            { content = [ text "Delete Modal" ]
            , title = "Delete Details"
            , footer =
                [ Ui.Container.rowEnd []
                    [ Ui.Button.primary "Save" CloseDeleteModal
                    , Ui.Button.secondary "Close" CloseDeleteModal
                    ]
                ]
            }
    in
        [ Ui.DropdownMenu.view actionDropdownViewModel ActionMenu ui.actionMenu
        , Ui.Modal.view EditModal editModalViewModel ui.editModal
        , Ui.Modal.view DeleteModal deleteModalViewModel ui.deleteModal
        ]


headerSite : Site -> UserAccess -> HeaderUi -> List (Html Msg)
headerSite site useraccess ui =
    let
        values =
            site.values

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )

        items =
            headerItems site

        headerContent =
            List.append
                (headerItems site)
                (headerActions site useraccess ui)
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content" ]
            headerContent
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]
