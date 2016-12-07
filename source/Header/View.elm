module Header.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Header.Messages exposing (..)
import Header.Models exposing (..)
import Ui.DropdownMenu
import Ui.IconButton
import Ui.Chooser
import Ui
import Ui.Modal
import Ui.Container
import Ui.Button


viewModel : Ui.DropdownMenu.ViewModel Msg
viewModel =
    { element =
        Ui.IconButton.secondary "Actions"
            "chevron-down"
            "right"
            Header.Messages.Nothing
    , items =
        [ Ui.DropdownMenu.item [ onClick OpenModal ]
            [ Ui.icon "android-download" True []
            , node "span" [] [ text "Download" ]
            ]
        , Ui.DropdownMenu.item [ onClick OpenModal ]
            [ Ui.icon "trash-b" True []
            , node "span" [] [ text "Delete" ]
            ]
        ]
    }


view : HeaderInfo -> Html Msg
view headerInfo =
    div [ class "body-header" ]
        (header headerInfo.header headerInfo.dropdownMenu headerInfo.modal)


header : Header -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
header header dropdownMenu modal =
    case header of
        RootHeader root ->
            headerRoot root dropdownMenu modal

        CustomerHeader customer ->
            headerCustomer customer dropdownMenu modal

        ClientHeader client ->
            headerClient client dropdownMenu modal

        SiteHeader site ->
            headerSite site dropdownMenu modal

        StaffHeader staff ->
            headerStaff staff dropdownMenu modal

        Empty ->
            headerEmpty


headerRoot : Root -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
headerRoot root dropdownMenu modal =
    [ text "Root"
    ]


headerCustomer : Customer -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
headerCustomer customer dropdownMenu modal =
    let
        access =
            customer.access

        values =
            customer.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )

        modalViewModel =
            { content =
                [ headerItem "Name" "globe" access.name values.name
                , headerItem "Address" "home" access.address address
                , headerItem "Contact" "user-o" access.contact values.contact
                , headerItem "Phone" "phone" access.contact values.tel
                , headerItem "Email" "envelope" access.contact values.email
                ]
            , title = "Details"
            , footer =
                [ Ui.Container.rowEnd []
                    [ Ui.Button.primary "Save" CloseModal
                    , Ui.Button.secondary "Close" CloseModal
                    ]
                ]
            }
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content clearfix pl2 pr2" ]
            [ headerItem "Name" "globe" access.name values.name
            , headerItem "Address" "home" access.address address
            , headerItem "Contact" "user-o" access.contact values.contact
            , headerItem "Phone" "phone" access.contact values.tel
            , headerItem "Email" "envelope" access.contact values.email
            , Ui.DropdownMenu.view viewModel DropdownMenu dropdownMenu
            , Ui.Modal.view Modal modalViewModel modal
            ]
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]


headerClient : Client -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
headerClient client dropdownMenu modal =
    let
        access =
            client.access

        values =
            client.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content clearfix pl2 pr2" ]
            [ headerItem "Ref" "wrench" access.name values.no
            , headerItem "Name" "globe" access.name values.name
            , headerItem "Address" "home" access.address address
            , headerItem "Contact" "user-o" access.contact values.contact
            , headerItem "Phone" "phone" access.contact values.tel
            , headerItem "Email" "envelope" access.contact values.email
            , (Ui.DropdownMenu.view viewModel DropdownMenu dropdownMenu)
            ]
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]


headerSite : Site -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
headerSite site dropdownMenu modal =
    let
        access =
            site.access

        values =
            site.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content clearfix pl2 pr2" ]
            [ headerItem "Ref" "wrench" access.name values.no
            , headerItem "Name" "globe" access.name values.name
            , headerItem "Address" "home" access.address address
            , headerItem "Contact" "user-o" access.contact values.contact
            , headerItem "Phone" "phone" access.contact values.tel
            , headerItem "Email" "envelope" access.contact values.email
            , headerItem "Division Mgr" "user-o" access.managers values.divisionMgr
            , headerItem "Area Mgr" "user-o" access.managers values.areaMgr
            , headerItem "Supervisor" "user-o" access.managers values.supervisor
            , (Ui.DropdownMenu.view viewModel DropdownMenu dropdownMenu)
            ]
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]


headerStaff : Staff -> Ui.DropdownMenu.Model -> Ui.Modal.Model -> List (Html Msg)
headerStaff staff dropdownMenu modal =
    let
        access =
            staff.access

        values =
            staff.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content clearfix pl2 pr2" ]
            [ headerItem "Ref" "wrench" access.name values.no
            , headerItem "Name" "globe" access.name values.name
            , headerItem "Address" "home" access.address address
            , headerItem "Tel" "phone" access.contact values.tel
            , headerItem "Mob" "phone" access.contact values.mob
            , headerItem "Email" "envelope" access.contact values.email
            , (Ui.DropdownMenu.view viewModel DropdownMenu dropdownMenu)
            ]
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]


headerEmpty : List (Html Msg)
headerEmpty =
    [ text "Empty"
    ]


headerItem : String -> String -> AccessType -> Maybe String -> Html Msg
headerItem title icon accessType maybeValue =
    let
        hidden =
            ( "display: none; height: 0px;", "" )

        ( style, textValue ) =
            case maybeValue of
                Just value ->
                    if accessType /= None && (String.length value) > 0 then
                        ( "display: block;", " " ++ value )
                    else
                        hidden

                Maybe.Nothing ->
                    hidden
    in
        p [ attribute "style" style ]
            [ abbr [ attribute "title" title ]
                [ i [ class ("fa fa-" ++ icon) ] [] ]
            , text textValue
            ]


fullAddress : Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String
fullAddress maybeAddress1 maybeAddress2 maybeAddress3 maybeAddress4 maybePostcode =
    [ maybeAddress1, maybeAddress2, maybeAddress3, maybeAddress4, maybePostcode ]
        |> List.map (\mb -> Maybe.withDefault "" mb)
        |> List.filter (\a -> String.length (a) > 0)
        |> String.join ", "
        |> Just
