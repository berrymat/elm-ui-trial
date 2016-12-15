module Header.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Header.Messages exposing (..)
import Header.Models exposing (..)
import Header.Utils exposing (..)
import Helpers.Helpers exposing (..)
import Ui.DropdownMenu
import Ui.IconButton
import Ui.Chooser
import Ui
import Ui.Modal
import Ui.Container
import Ui.Button
import Header.Root.View exposing (headerRoot)
import Header.Customer.View exposing (headerCustomer)
import Header.Client.View exposing (headerClient)
import Header.Site.View exposing (headerSite)
import Header.Staff.View exposing (headerStaff)
import RemoteData exposing (..)


view : HeaderInfo -> Html Msg
view headerInfo =
    div [ class "body-header" ]
        (case headerInfo.data of
            NotAsked ->
                [ text "Initializing." ]

            Loading ->
                [ text "Loading." ]

            Failure err ->
                [ text ("Error: " ++ toString err) ]

            Success data ->
                (header data.header data.useraccess headerInfo.ui)
        )


header : Header -> UserAccess -> HeaderUi -> List (Html Msg)
header header ua ui =
    case header of
        RootHeader root ->
            headerRoot root ua ui

        CustomerHeader customer ->
            headerCustomer customer ua ui

        ClientHeader client ->
            headerClient client ua ui

        SiteHeader site ->
            headerSite site ua ui

        StaffHeader staff ->
            headerStaff staff ua ui

        Empty ->
            headerEmpty


headerEmpty : List (Html Msg)
headerEmpty =
    [ text "Empty"
    ]
