module Teams.Models exposing (..)


type alias TeamId =
    String


type alias Team =
    { id : TeamId
    , name : String
    , level : Int
    }


new : Team
new =
    { id = "0"
    , name = ""
    , level = 1
    }
