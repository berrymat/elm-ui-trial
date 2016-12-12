module Customer.Models exposing (..)

import Helpers.Models exposing (..)
import Tree.Models exposing (NodeId)


type alias CustomerData =
    { id : NodeId
    , access : CustomerAccess
    , values : CustomerValues
    , useraccess : UserAccess
    }


type alias CustomerAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


initCustomerAccess : CustomerAccess
initCustomerAccess =
    CustomerAccess None None None None


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


initCustomerValues : CustomerValues
initCustomerValues =
    CustomerValues Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing
