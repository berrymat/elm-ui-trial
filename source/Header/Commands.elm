module Header.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Header.Messages exposing (..)
import Header.Models exposing (..)
import Tree.Models exposing (NodeType(..), NodeId)
import Ui.DropdownMenu


fetchHeader : String -> NodeType -> NodeId -> Cmd Msg
fetchHeader origin nodeType nodeId =
    if nodeId /= "" then
        case nodeType of
            RootType ->
                fetchRoot origin nodeId

            CustomerType ->
                fetchCustomer origin nodeId

            ClientType ->
                fetchClient origin nodeId

            SiteType ->
                fetchSite origin nodeId

            StaffType ->
                fetchStaff origin nodeId

            FolderType ->
                Cmd.none
    else
        Cmd.none


fetchRoot : String -> NodeId -> Cmd Msg
fetchRoot origin nodeId =
    Http.get (rootUrl origin nodeId) rootDecoder
        |> Http.send (OnFetchRoot nodeId)


fetchCustomer : String -> NodeId -> Cmd Msg
fetchCustomer origin nodeId =
    Http.get (customerUrl origin nodeId) customerDecoder
        |> Http.send (OnFetchCustomer nodeId)


fetchClient : String -> NodeId -> Cmd Msg
fetchClient origin nodeId =
    Http.get (clientUrl origin nodeId) clientDecoder
        |> Http.send (OnFetchClient nodeId)


fetchSite : String -> NodeId -> Cmd Msg
fetchSite origin nodeId =
    Http.get (siteUrl origin nodeId) siteDecoder
        |> Http.send (OnFetchSite nodeId)


fetchStaff : String -> NodeId -> Cmd Msg
fetchStaff origin nodeId =
    Http.get (staffUrl origin nodeId) staffDecoder
        |> Http.send (OnFetchStaff nodeId)


apiUrl : String -> String
apiUrl origin =
    origin ++ "api/"


rootUrl : String -> NodeId -> String
rootUrl origin nodeId =
    (apiUrl origin) ++ "Roots/" ++ nodeId


customerUrl : String -> NodeId -> String
customerUrl origin nodeId =
    (apiUrl origin) ++ "Customers/" ++ nodeId


clientUrl : String -> NodeId -> String
clientUrl origin nodeId =
    (apiUrl origin) ++ "Clients/" ++ nodeId


siteUrl : String -> NodeId -> String
siteUrl origin nodeId =
    (apiUrl origin) ++ "Sites/" ++ nodeId


staffUrl : String -> NodeId -> String
staffUrl origin nodeId =
    (apiUrl origin) ++ "Staff/" ++ nodeId



-- DECODERS


rootDecoder : Decode.Decoder HeaderInfo
rootDecoder =
    Decode.map2 headerInfo
        (Decode.map RootHeader
            (Decode.map2 Root
                (field "id" Decode.string)
                (field "name" Decode.string)
            )
        )
        (field "tabs" (Decode.list tabDecoder))



-- Customer


customerDecoder : Decode.Decoder HeaderInfo
customerDecoder =
    Decode.map2 headerInfo
        (Decode.map CustomerHeader
            (decode Customer
                |> required "id" Decode.string
                |> required "access" customerAccessDecoder
                |> required "values" customerValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))


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


clientDecoder : Decode.Decoder HeaderInfo
clientDecoder =
    Decode.map2 headerInfo
        (Decode.map ClientHeader
            (decode Client
                |> required "id" Decode.string
                |> required "access" clientAccessDecoder
                |> required "values" clientValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))


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


siteDecoder : Decode.Decoder HeaderInfo
siteDecoder =
    Decode.map2 headerInfo
        (Decode.map SiteHeader
            (decode Site
                |> required "id" Decode.string
                |> required "access" siteAccessDecoder
                |> required "values" siteValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))


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


staffDecoder : Decode.Decoder HeaderInfo
staffDecoder =
    Decode.map2 headerInfo
        (Decode.map StaffHeader
            (decode Staff
                |> required "id" Decode.string
                |> required "access" staffAccessDecoder
                |> required "values" staffValuesDecoder
            )
        )
        (field "tabs" (Decode.list tabDecoder))


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
