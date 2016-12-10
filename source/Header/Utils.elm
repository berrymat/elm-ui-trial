module Header.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Header.Models exposing (..)
import Header.Messages exposing (..)


headerItem : String -> String -> AccessType -> Maybe String -> Html Msg
headerItem title icon accessType maybeValue =
    let
        hidden =
            ( "display: none; height: 0px;", "" )

        ( style, textValue ) =
            case maybeValue of
                Just value ->
                    if accessType /= None && (String.length value) > 0 then
                        ( "display: block;", " " ++ value )
                    else
                        hidden

                Maybe.Nothing ->
                    hidden
    in
        p [ attribute "style" style ]
            [ abbr [ attribute "title" title ]
                [ i [ class ("fa fa-" ++ icon) ] [] ]
            , text textValue
            ]
