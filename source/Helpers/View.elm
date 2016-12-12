module Helpers.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers.Models exposing (..)


headerItem : String -> String -> AccessType -> Maybe String -> Html msg
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
