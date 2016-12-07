module Teams.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href)
import Html.Events exposing (onClick)
import Teams.Messages exposing (..)
import Teams.Models exposing (..)


view : Team -> Html.Html Msg
view model =
    div [ class "fullview" ]
        [ nav model
        , form model
        ]


nav : Team -> Html.Html Msg
nav model =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]


form : Team -> Html.Html Msg
form team =
    div [ class "m3" ]
        [ h1 [] [ text team.name ]
        , formLevel team
        ]


formLevel : Team -> Html.Html Msg
formLevel team =
    div
        [ class "clearfix py1"
        ]
        [ div [ class "col col-5" ] [ text "Level" ]
        , div [ class "col col-7" ]
            [ span [ class "h2 bold" ] [ text (toString team.level) ]
            , btnLevelDecrease team
            , btnLevelIncrease team
            ]
        ]


btnLevelDecrease : Team -> Html.Html Msg
btnLevelDecrease team =
    a [ class "btn ml1 h1", onClick (ChangeLevel team.id -1) ]
        [ i [ class "fa fa-minus-circle" ] [] ]


btnLevelIncrease : Team -> Html.Html Msg
btnLevelIncrease team =
    a [ class "btn ml1 h1", onClick (ChangeLevel team.id 1) ]
        [ i [ class "fa fa-plus-circle" ] [] ]


listBtn : Html Msg
listBtn =
    button
        [ class "btn regular"
        , onClick ShowTeams
        ]
        [ i [ class "fa fa-chevron-left mr1" ] [], text "List" ]
