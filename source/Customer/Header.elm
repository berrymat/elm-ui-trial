module Customer.Header exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Customer.Models exposing (..)
import RemoteData exposing (..)
import Helpers.Helpers exposing (..)
import Helpers.View exposing (..)


-- MODEL


type alias Model =
    { data : WebData CustomerData
    }


init : Model
init =
    Model
        NotAsked



-- UPDATE


type Msg
    = CustomerResponse (WebData CustomerData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CustomerResponse customerData ->
            ( { model | data = customerData }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "body-header" ]
        (case model.data of
            NotAsked ->
                [ text "Initializing." ]

            Loading ->
                [ text "Loading." ]

            Failure err ->
                [ text ("Error: " ++ toString err) ]

            Success data ->
                (headerCustomer data)
        )


headerCustomer : CustomerData -> List (Html Msg)
headerCustomer data =
    let
        values =
            data.values

        backgroundImage =
            case values.image of
                Just image ->
                    ( "background-image", "url('" ++ image ++ "')" )

                Maybe.Nothing ->
                    ( "display", "none" )

        headerContent =
            List.append
                (headerItems data)
                (headerActions data)
    in
        [ div
            [ class "body-header-image"
            , style [ backgroundImage ]
            ]
            []
        , div [ class "body-header-content" ]
            headerContent
        , div [ class "body-header-extra" ]
            [ text "Extra" ]
        ]


headerItems : CustomerData -> List (Html Msg)
headerItems data =
    let
        access =
            data.access

        values =
            data.values

        address =
            fullAddress values.address1 values.address2 values.address3 values.address4 values.postcode
    in
        [ headerItem "Name" "globe" access.name values.name
        , headerItem "Address" "home" access.address address
        , headerItem "Contact" "user-o" access.contact values.contact
        , headerItem "Phone" "phone" access.contact values.tel
        , headerItem "Email" "envelope" access.contact values.email
        ]


headerActions : CustomerData -> List (Html Msg)
headerActions data =
    [ text "Actions" ]
