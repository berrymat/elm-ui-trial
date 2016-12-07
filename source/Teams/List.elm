module Teams.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Teams.Messages exposing (..)
import Teams.Models exposing (Team)


view : List Team -> Html Msg
view teams =
    div [ class "fullview" ]
        [ nav teams
        , list teams
        ]


nav : List Team -> Html Msg
nav teams =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Teams" ] ]


list : List Team -> Html Msg
list teams =
    let
        teamRows =
            List.map teamRow teams

        headerRow =
            div [ class "row header green" ]
                [ div [ class "cell" ] [ text "Id" ]
                , div [ class "cell" ] [ text "Name" ]
                , div [ class "cell" ] [ text "Level" ]
                , div [ class "cell" ] [ text "Actions" ]
                ]

        allRows =
            headerRow :: teamRows
    in
        div [ class "wrapper" ]
            [ div [ class "table" ] allRows
            ]


teamRow : Team -> Html Msg
teamRow team =
    div [ class "row" ]
        [ div [ class "cell" ] [ text team.id ]
        , div [ class "cell" ] [ text team.name ]
        , div [ class "cell" ] [ text (toString team.level) ]
        , div [ class "cell" ]
            [ editBtn team ]
        ]


editBtn : Team -> Html.Html Msg
editBtn team =
    button
        [ class "btn regular p0"
        , onClick (ShowTeam team.id)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]
