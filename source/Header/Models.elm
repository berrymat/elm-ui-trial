module Header.Models exposing (..)

import Tree.Models exposing (NodeId)
import RemoteData exposing (..)
import Ui.DropdownMenu
import Ui.Modal
import Ui.Input


type Header
    = RootHeader Root
    | CustomerHeader Customer
    | ClientHeader Client
    | SiteHeader Site
    | StaffHeader Staff
    | Empty


type alias HeaderData =
    { header : Header
    , tabs : List Tab
    , useraccess : UserAccess
    }


type alias HeaderUi =
    { actionMenu : Ui.DropdownMenu.Model
    , editModal : Ui.Modal.Model
    , deleteModal : Ui.Modal.Model
    }


type alias HeaderInfo =
    { data : WebData HeaderData
    , ui : HeaderUi
    }


initialHeaderInfo : HeaderInfo
initialHeaderInfo =
    HeaderInfo NotAsked initialHeaderUi


initialHeaderUi : HeaderUi
initialHeaderUi =
    { actionMenu = Ui.DropdownMenu.init
    , editModal = Ui.Modal.init
    , deleteModal = Ui.Modal.init
    }


type AccessType
    = None
    | Read
    | Write


convertAccessType : String -> AccessType
convertAccessType type_ =
    if type_ == "r" then
        Read
    else if type_ == "w" then
        Write
    else
        None


type alias Root =
    { id : NodeId
    , access : RootAccess
    , values : RootValues
    }


type alias RootAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


type alias RootValues =
    { name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , contact : Maybe String
    , tel : Maybe String
    , email : Maybe String
    }


type alias CustomerUi =
    { nameInput : Ui.Input.Model
    , address1Input : Ui.Input.Model
    , address2Input : Ui.Input.Model
    , address3Input : Ui.Input.Model
    , address4Input : Ui.Input.Model
    }


customerUi : CustomerUi
customerUi =
    { nameInput = Ui.Input.init "" "Placeholder..."
    , address1Input = Ui.Input.init "" "Placeholder..."
    , address2Input = Ui.Input.init "" "Placeholder..."
    , address3Input = Ui.Input.init "" "Placeholder..."
    , address4Input = Ui.Input.init "" "Placeholder..."
    }


type alias Customer =
    { id : NodeId
    , access : CustomerAccess
    , values : CustomerValues
    , ui : CustomerUi
    }


customer : NodeId -> CustomerAccess -> CustomerValues -> Customer
customer id access values =
    Customer id access values customerUi


type alias CustomerAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


type alias CustomerValues =
    { name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , contact : Maybe String
    , tel : Maybe String
    , email : Maybe String
    }


type alias Client =
    { id : NodeId
    , access : ClientAccess
    , values : ClientValues
    }


type alias ClientValues =
    { no : Maybe String
    , name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , contact : Maybe String
    , tel : Maybe String
    , email : Maybe String
    }


type alias ClientAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


type alias Site =
    { id : NodeId
    , access : SiteAccess
    , values : SiteValues
    }


type alias SiteValues =
    { no : Maybe String
    , name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , contact : Maybe String
    , tel : Maybe String
    , email : Maybe String
    , divisionMgr : Maybe String
    , areaMgr : Maybe String
    , supervisor : Maybe String
    }


type alias SiteAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    , managers : AccessType
    }


type alias Staff =
    { id : NodeId
    , access : StaffAccess
    , values : StaffValues
    }


type alias StaffValues =
    { no : Maybe String
    , name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , tel : Maybe String
    , mob : Maybe String
    , email : Maybe String
    }


type alias StaffAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


type TabType
    = FoldersType
    | UsersType
    | CasesType
    | EmptyTab


type alias Tab =
    { tabType : TabType
    , name : String
    }


type alias UserAccess =
    { admin : Bool
    , owner : Bool
    , root : Bool
    }


extractId : HeaderData -> NodeId
extractId data =
    case data.header of
        RootHeader root ->
            root.id

        CustomerHeader customer ->
            customer.id

        ClientHeader client ->
            client.id

        SiteHeader site ->
            site.id

        StaffHeader staff ->
            staff.id

        Empty ->
            ""


headerId : HeaderInfo -> NodeId
headerId headerInfo =
    RemoteData.map extractId headerInfo.data
        |> RemoteData.withDefault ""


isHeaderEmpty : HeaderInfo -> Bool
isHeaderEmpty headerInfo =
    (headerInfo.data == NotAsked)


getTabFromType : HeaderInfo -> TabType -> Tab
getTabFromType headerInfo tabType =
    let
        tabs =
            RemoteData.map (\data -> data.tabs) headerInfo.data
                |> RemoteData.withDefault []

        maybeTab =
            tabs
                |> List.filter (\t -> t.tabType == tabType)
                |> List.head

        updatedTab =
            case maybeTab of
                Just tab ->
                    tab

                Nothing ->
                    tabs
                        |> List.head
                        |> Maybe.withDefault (Tab EmptyTab "")
    in
        updatedTab
