module Main exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model, initialModel)
import Navigation exposing (Location)
import Routing exposing (Route)
import Update exposing (update, fetchData)
import View exposing (view)
import Container.Update


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initialModel currentRoute
    in
        ( model, fetchData model )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map ContainerMsg (Container.Update.subscriptions model.container)
        ]


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
