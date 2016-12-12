module Header.Customer.Header exposing (..)

-- MODEL


type alias CustomerUi =
    { nameInput : Ui.Input.Model
    , address1Input : Ui.Input.Model
    , address2Input : Ui.Input.Model
    , address3Input : Ui.Input.Model
    , address4Input : Ui.Input.Model
    }


initCustomerUi : CustomerUi
initCustomerUi =
    CustomerUi
        (Ui.Input.init "" "Placeholder...")
        (Ui.Input.init "" "Placeholder...")
        (Ui.Input.init "" "Placeholder...")
        (Ui.Input.init "" "Placeholder...")
        (Ui.Input.init "" "Placeholder...")




type alias Customer =
    { data : CustomerData
    , ui : CustomerUi
    }


init : ( Customer, Cmd Msg )
init =
    ( Customer initCustomerData initCustomerUi, Cmd.none )



-- UPDATE


type Msg
    = Input String
    | Send
    | NewMessage String


update : Msg -> Customer -> ( Customer, Cmd Msg )
update msg { input, messages } =
    case msg of
        Input newInput ->
            ( Customer newInput messages, Cmd.none )

        Send ->
            ( Customer "" messages, WebSocket.send "ws://echo.websocket.org" input )

        NewMessage str ->
            ( Customer input (str :: messages), Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Customer -> Sub Msg
subscriptions customer =
    WebSocket.listen "ws://echo.websocket.org" NewMessage



-- VIEW


view : Customer -> Html Msg
view customer =
    div []
        [ div [] (List.map viewMessage customer.messages)
        , input [ onInput Input ] []
        , button [ onClick Send ] [ text "Send" ]
        ]
