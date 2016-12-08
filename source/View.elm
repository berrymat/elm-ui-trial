module View exposing (..)

import Html exposing (Html, div, span, strong, text)
import Html.Attributes exposing (class)
import Ui.App
import Ui
import Ui.Layout
import Ui.Header
import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.Edit
import Players.List
import Players.Messages exposing (Msg(..))
import Players.Models exposing (PlayerId)
import Teams.Edit
import Teams.List
import Teams.Messages exposing (Msg(..))
import Teams.Models exposing (TeamId)
import Container.View
import Container.Messages exposing (Msg(..))
import Routing exposing (Route(..))


view : Model -> Html Messages.Msg
view model =
    Ui.App.view
        App
        model.app
        [ Ui.Layout.website
            [ nav model ]
            [ page model ]
            [ footer model ]
        ]


nav : Model -> Html Messages.Msg
nav model =
    Ui.Header.view
        [ Ui.Header.title
            { text = "Home"
            , action = Nothing
            , link = Nothing
            , target = ""
            }
        , Ui.spacer
        , Ui.Header.item
            { text = "Teams"
            , action = Just (TeamsMsg ShowTeams)
            , link = Nothing
            , target = ""
            }
        , Ui.Header.separator
        , Ui.Header.item
            { text = "Players"
            , action = Just (PlayersMsg ShowPlayers)
            , link = Nothing
            , target = ""
            }
        , Ui.Header.separator
        , Ui.Header.item
            { text = "Container"
            , action = Just (ContainerMsg ShowContainer)
            , link = Nothing
            , target = ""
            }
        , Ui.Header.separator
        , Ui.Header.icon
            { glyph = "navicon-round"
            , action = Nothing
            , link = Nothing
            , target = ""
            , size = 24
            }
        ]


footer : Model -> Html Messages.Msg
footer model =
    div [ class "footer clearfix p1" ]
        [ text "Elm prototype" ]


page : Model -> Html Messages.Msg
page model =
    case model.route of
        PlayersRoute ->
            Html.map PlayersMsg (Players.List.view model.players)

        PlayerRoute id ->
            playerEditPage model id

        TeamsRoute ->
            Html.map TeamsMsg (Teams.List.view model.teams)

        TeamRoute id ->
            teamEditPage model id

        ContainerRoute type_ id ->
            Html.map ContainerMsg
                (Container.View.view
                    model.container
                )

        NotFoundRoute ->
            notFoundView


playerEditPage : Model -> PlayerId -> Html Messages.Msg
playerEditPage model playerId =
    let
        maybePlayer =
            model.players
                |> List.filter (\player -> player.id == playerId)
                |> List.head
    in
        case maybePlayer of
            Just player ->
                Html.map PlayersMsg (Players.Edit.view player)

            Nothing ->
                notFoundView


teamEditPage : Model -> TeamId -> Html Messages.Msg
teamEditPage model teamId =
    let
        maybeTeam =
            model.teams
                |> List.filter (\team -> team.id == teamId)
                |> List.head
    in
        case maybeTeam of
            Just team ->
                Html.map TeamsMsg (Teams.Edit.view team)

            Nothing ->
                notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
