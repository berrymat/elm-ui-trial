module Teams.Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Teams.Messages exposing (..)
import Teams.Models exposing (TeamId, Team)


fetchAll : Cmd Msg
fetchAll =
    Http.get fetchAllUrl collectionDecoder
        |> Http.send OnFetchAll


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/teams"


saveUrl : TeamId -> String
saveUrl teamId =
    "http://localhost:4000/teams/" ++ teamId


saveRequest : Team -> Http.Request Team
saveRequest team =
    Http.request
        { body = memberEncoded team |> Http.jsonBody
        , expect = Http.expectJson memberDecoder
        , headers = []
        , method = "PATCH"
        , timeout = Nothing
        , url = saveUrl team.id
        , withCredentials = False
        }


save : Team -> Cmd Msg
save team =
    saveRequest team
        |> Http.send OnSave



-- DECODERS


collectionDecoder : Decode.Decoder (List Team)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Team
memberDecoder =
    Decode.map3 Team
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "level" Decode.int)


memberEncoded : Team -> Encode.Value
memberEncoded team =
    let
        list =
            [ ( "id", Encode.string team.id )
            , ( "name", Encode.string team.name )
            , ( "level", Encode.int team.level )
            ]
    in
        list
            |> Encode.object
