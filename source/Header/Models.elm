module Header.Models exposing (..)

import Tree.Models exposing (NodeId)
import Ui.DropdownMenu
import Ui.Modal


type Header
    = RootHeader Root
    | CustomerHeader Customer
    | ClientHeader Client
    | SiteHeader Site
    | StaffHeader Staff
    | Empty


type alias HeaderInfo =
    { header : Header
    , dropdownMenu : Ui.DropdownMenu.Model
    , modal : Ui.Modal.Model
    , tabs : List Tab
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
    , name : String
    }


type alias Customer =
    { id : NodeId
    , access : CustomerAccess
    , values : CustomerValues
    }


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


initialHeaderInfo : HeaderInfo
initialHeaderInfo =
    headerInfo Empty []


headerInfo : Header -> List Tab -> HeaderInfo
headerInfo header tabs =
    { header = header
    , dropdownMenu = Ui.DropdownMenu.init
    , modal = Ui.Modal.init
    , tabs = tabs
    }


headerId : HeaderInfo -> NodeId
headerId headerInfo =
    case headerInfo.header of
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
