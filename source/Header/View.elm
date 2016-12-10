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


view : HeaderInfo -> Html Msg
view headerInfo =
    div [ class "body-header" ]
        (header headerInfo)


header : HeaderInfo -> List (Html Msg)
header headerInfo =
    case headerInfo.header of
        RootHeader root ->
            headerRoot headerInfo root

        CustomerHeader customer ->
            headerCustomer headerInfo customer

        ClientHeader client ->
            headerClient headerInfo client

        SiteHeader site ->
            headerSite headerInfo site

        StaffHeader staff ->
            headerStaff headerInfo staff

        Empty ->
            headerEmpty


headerEmpty : List (Html Msg)
headerEmpty =
    [ text "Empty"
    ]
