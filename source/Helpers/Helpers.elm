module Helpers.Helpers exposing (..)

import Ui.Helpers.Env
import Json.Decode as Decode
import Http
import HttpBuilder exposing (..)


apiUrl : String
apiUrl =
    let
        endpoint =
            Ui.Helpers.Env.get "endpoint" Decode.string
                |> Result.withDefault "http://localhost"
    in
        endpoint ++ "api/"


fetcher : String -> Decode.Decoder a -> (Result Http.Error a -> msg) -> Cmd msg
fetcher url decoder msg =
    HttpBuilder.get url
        |> withExpect (Http.expectJson decoder)
        |> withCredentials
        |> send msg


fullAddress : Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String -> Maybe String
fullAddress maybeAddress1 maybeAddress2 maybeAddress3 maybeAddress4 maybePostcode =
    [ maybeAddress1, maybeAddress2, maybeAddress3, maybeAddress4, maybePostcode ]
        |> List.map (\mb -> Maybe.withDefault "" mb)
        |> List.filter (\a -> String.length (a) > 0)
        |> String.join ", "
        |> Just
