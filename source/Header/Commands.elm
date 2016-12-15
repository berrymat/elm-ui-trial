module Header.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Header.Messages exposing (..)
import Header.Models exposing (..)
import Tree.Models exposing (NodeType(..), NodeId)
import Ui.DropdownMenu
import Helpers.Helpers exposing (apiUrl, fetcher)
import HttpBuilder exposing (..)
import RemoteData exposing (..)


fetchHeader : NodeType -> NodeId -> Cmd Msg
fetchHeader nodeType nodeId =
    if nodeId /= "" then
        case nodeType of
            RootType ->
                fetchRoot nodeId

            CustomerType ->
                fetchCustomer nodeId

            ClientType ->
                fetchClient nodeId

            SiteType ->
                fetchSite nodeId

            StaffType ->
                fetchStaff nodeId

            FolderType ->
                Cmd.none
    else
        Cmd.none


fetchRoot : NodeId -> Cmd Msg
fetchRoot nodeId =
    fetcher (rootUrl nodeId) rootDecoder (HeaderResponse << RemoteData.fromResult)


fetchCustomer : NodeId -> Cmd Msg
fetchCustomer nodeId =
    fetcher (customerUrl nodeId) customerDecoder (HeaderResponse << RemoteData.fromResult)


fetchClient : NodeId -> Cmd Msg
fetchClient nodeId =
    fetcher (clientUrl nodeId) clientDecoder (HeaderResponse << RemoteData.fromResult)


fetchSite : NodeId -> Cmd Msg
fetchSite nodeId =
    fetcher (siteUrl nodeId) siteDecoder (HeaderResponse << RemoteData.fromResult)


fetchStaff : NodeId -> Cmd Msg
fetchStaff nodeId =
    fetcher (staffUrl nodeId) staffDecoder (HeaderResponse << RemoteData.fromResult)


rootUrl : NodeId -> String
rootUrl nodeId =
    apiUrl ++ "Roots/" ++ nodeId


customerUrl : NodeId -> String
customerUrl nodeId =
    apiUrl ++ "Customers/" ++ nodeId


clientUrl : NodeId -> String
clientUrl nodeId =
    apiUrl ++ "Clients/" ++ nodeId


siteUrl : NodeId -> String
siteUrl nodeId =
    apiUrl ++ "Sites/" ++ nodeId


staffUrl : NodeId -> String
staffUrl nodeId =
    apiUrl ++ "Staff/" ++ nodeId



-- DECODERS


rootDecoder : Decode.Decoder HeaderData
rootDecoder =
    Decode.map3 HeaderData
        (Decode.map RootHeader
            (decode Root
                |> required "id" Decode.string
                |> required "access" rootAccessDecoder
                |> required "values" rootValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))
        (field "useraccess" useraccessDecoder)


rootAccessDecoder : Decode.Decoder RootAccess
rootAccessDecoder =
    decode createRootAccess
        |> required "name" Decode.string
        |> required "image" Decode.string
        |> required "address" Decode.string
        |> required "contact" Decode.string


createRootAccess : String -> String -> String -> String -> RootAccess
createRootAccess name image address contact =
    RootAccess
        (convertAccessType name)
        (convertAccessType image)
        (convertAccessType address)
        (convertAccessType contact)


rootValuesDecoder : Decode.Decoder RootValues
rootValuesDecoder =
    decode RootValues
        |> required "name" (Decode.nullable Decode.string)
        |> required "image" (Decode.nullable Decode.string)
        |> required "address1" (Decode.nullable Decode.string)
        |> required "address2" (Decode.nullable Decode.string)
        |> required "address3" (Decode.nullable Decode.string)
        |> required "address4" (Decode.nullable Decode.string)
        |> required "postcode" (Decode.nullable Decode.string)
        |> required "contact" (Decode.nullable Decode.string)
        |> required "tel" (Decode.nullable Decode.string)
        |> required "email" (Decode.nullable Decode.string)



-- Customer


customerDecoder : Decode.Decoder HeaderData
customerDecoder =
    Decode.map3 HeaderData
        (Decode.map CustomerHeader
            (decode customer
                |> required "id" Decode.string
                |> required "access" customerAccessDecoder
                |> required "values" customerValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))
        (field "useraccess" useraccessDecoder)


customerAccessDecoder : Decode.Decoder CustomerAccess
customerAccessDecoder =
    decode createCustomerAccess
        |> required "name" Decode.string
        |> required "image" Decode.string
        |> required "address" Decode.string
        |> required "contact" Decode.string


createCustomerAccess : String -> String -> String -> String -> CustomerAccess
createCustomerAccess name image address contact =
    CustomerAccess
        (convertAccessType name)
        (convertAccessType image)
        (convertAccessType address)
        (convertAccessType contact)


customerValuesDecoder : Decode.Decoder CustomerValues
customerValuesDecoder =
    decode CustomerValues
        |> required "name" (Decode.nullable Decode.string)
        |> required "image" (Decode.nullable Decode.string)
        |> required "address1" (Decode.nullable Decode.string)
        |> required "address2" (Decode.nullable Decode.string)
        |> required "address3" (Decode.nullable Decode.string)
        |> required "address4" (Decode.nullable Decode.string)
        |> required "postcode" (Decode.nullable Decode.string)
        |> required "contact" (Decode.nullable Decode.string)
        |> required "tel" (Decode.nullable Decode.string)
        |> required "email" (Decode.nullable Decode.string)



-- Client


clientDecoder : Decode.Decoder HeaderData
clientDecoder =
    Decode.map3 HeaderData
        (Decode.map ClientHeader
            (decode Client
                |> required "id" Decode.string
                |> required "access" clientAccessDecoder
                |> required "values" clientValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))
        (field "useraccess" useraccessDecoder)


clientAccessDecoder : Decode.Decoder ClientAccess
clientAccessDecoder =
    decode createClientAccess
        |> required "name" Decode.string
        |> required "image" Decode.string
        |> required "address" Decode.string
        |> required "contact" Decode.string


createClientAccess : String -> String -> String -> String -> ClientAccess
createClientAccess name image address contact =
    ClientAccess
        (convertAccessType name)
        (convertAccessType image)
        (convertAccessType address)
        (convertAccessType contact)


clientValuesDecoder : Decode.Decoder ClientValues
clientValuesDecoder =
    decode ClientValues
        |> required "no" (Decode.nullable Decode.string)
        |> required "name" (Decode.nullable Decode.string)
        |> required "image" (Decode.nullable Decode.string)
        |> required "address1" (Decode.nullable Decode.string)
        |> required "address2" (Decode.nullable Decode.string)
        |> required "address3" (Decode.nullable Decode.string)
        |> required "address4" (Decode.nullable Decode.string)
        |> required "postcode" (Decode.nullable Decode.string)
        |> required "contact" (Decode.nullable Decode.string)
        |> required "tel" (Decode.nullable Decode.string)
        |> required "email" (Decode.nullable Decode.string)



-- Site


siteDecoder : Decode.Decoder HeaderData
siteDecoder =
    Decode.map3 HeaderData
        (Decode.map SiteHeader
            (decode Site
                |> required "id" Decode.string
                |> required "access" siteAccessDecoder
                |> required "values" siteValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))
        (field "useraccess" useraccessDecoder)


siteAccessDecoder : Decode.Decoder SiteAccess
siteAccessDecoder =
    decode createSiteAccess
        |> required "name" Decode.string
        |> required "image" Decode.string
        |> required "address" Decode.string
        |> required "contact" Decode.string
        |> required "managers" Decode.string


createSiteAccess : String -> String -> String -> String -> String -> SiteAccess
createSiteAccess name image address contact managers =
    SiteAccess
        (convertAccessType name)
        (convertAccessType image)
        (convertAccessType address)
        (convertAccessType contact)
        (convertAccessType managers)


siteValuesDecoder : Decode.Decoder SiteValues
siteValuesDecoder =
    decode SiteValues
        |> required "no" (Decode.nullable Decode.string)
        |> required "name" (Decode.nullable Decode.string)
        |> required "image" (Decode.nullable Decode.string)
        |> required "address1" (Decode.nullable Decode.string)
        |> required "address2" (Decode.nullable Decode.string)
        |> required "address3" (Decode.nullable Decode.string)
        |> required "address4" (Decode.nullable Decode.string)
        |> required "postcode" (Decode.nullable Decode.string)
        |> required "contact" (Decode.nullable Decode.string)
        |> required "tel" (Decode.nullable Decode.string)
        |> required "email" (Decode.nullable Decode.string)
        |> required "divisionMgr" (Decode.nullable Decode.string)
        |> required "areaMgr" (Decode.nullable Decode.string)
        |> required "supervisor" (Decode.nullable Decode.string)



-- Staff


staffDecoder : Decode.Decoder HeaderData
staffDecoder =
    Decode.map3 HeaderData
        (Decode.map StaffHeader
            (decode Staff
                |> required "id" Decode.string
                |> required "access" staffAccessDecoder
                |> required "values" staffValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))
        (field "useraccess" useraccessDecoder)


staffAccessDecoder : Decode.Decoder StaffAccess
staffAccessDecoder =
    decode createStaffAccess
        |> required "name" Decode.string
        |> required "image" Decode.string
        |> required "address" Decode.string
        |> required "contact" Decode.string


createStaffAccess : String -> String -> String -> String -> StaffAccess
createStaffAccess name image address contact =
    StaffAccess
        (convertAccessType name)
        (convertAccessType image)
        (convertAccessType address)
        (convertAccessType contact)


staffValuesDecoder : Decode.Decoder StaffValues
staffValuesDecoder =
    decode StaffValues
        |> required "no" (Decode.nullable Decode.string)
        |> required "name" (Decode.nullable Decode.string)
        |> required "image" (Decode.nullable Decode.string)
        |> required "address1" (Decode.nullable Decode.string)
        |> required "address2" (Decode.nullable Decode.string)
        |> required "address3" (Decode.nullable Decode.string)
        |> required "address4" (Decode.nullable Decode.string)
        |> required "postcode" (Decode.nullable Decode.string)
        |> required "tel" (Decode.nullable Decode.string)
        |> required "mob" (Decode.nullable Decode.string)
        |> required "email" (Decode.nullable Decode.string)


createTab : NodeId -> String -> Tab
createTab id name =
    if id == "folders" then
        Tab FoldersType name
    else if id == "users" then
        Tab UsersType name
    else if id == "cases" then
        Tab CasesType name
    else
        Tab FoldersType name


tabDecoder : Decode.Decoder Tab
tabDecoder =
    Decode.map2 createTab
        (field "id" Decode.string)
        (field "name" Decode.string)


useraccessDecoder : Decode.Decoder UserAccess
useraccessDecoder =
    Decode.map3 UserAccess
        (field "admin" Decode.bool)
        (field "owner" Decode.bool)
        (field "root" Decode.bool)
