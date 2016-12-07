module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, attribute, href, id)
import Html.Events exposing (onClick)
import Players.Messages exposing (..)
import Players.Models exposing (Player)


view : List Player -> Html Msg
view players =
    div [ class "fullview" ]
        [ nav players
        , list players
        ]


nav : List Player -> Html Msg
nav players =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Players" ] ]


list : List Player -> Html Msg
list players =
    let
        playerRows =
            List.map playerRow players

        headerRow =
            div [ class "row header green" ]
                [ div [ class "cell" ] [ text "Id" ]
                , div [ class "cell" ] [ text "Name" ]
                , div [ class "cell" ] [ text "Level" ]
                , div [ class "cell" ] [ text "Actions" ]
                ]

        allRows =
            headerRow :: playerRows
    in
        div [ class "wrapper" ]
            [ div [ class "table" ] allRows
            ]


playerRow : Player -> Html Msg
playerRow player =
    div [ class "row" ]
        [ div [ class "cell" ] [ text player.id ]
        , div [ class "cell" ] [ text player.name ]
        , div [ class "cell" ] [ text (toString player.level) ]
        , div [ class "cell" ]
            [ editBtn player ]
        ]


editBtn : Player -> Html.Html Msg
editBtn player =
    button
        [ class "btn regular p0"
        , onClick (ShowPlayer player.id)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]
