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


type alias CustomerAccess =
    { name : AccessType
    , image : AccessType
    , address : AccessType
    , contact : AccessType
    }


initCustomerAccess : CustomerAccess
initCustomerAccess =
    CustomerAccess None None None None


type alias CustomerValues =
    { name : Maybe String
    , image : Maybe String
    , address1 : Maybe String
    , address2 : Maybe String
    , address3 : Maybe String
    , address4 : Maybe String
    , postcode : Maybe String
    , contact : Maybe String
    , tel : Maybe String
    , email : Maybe String
    }


initCustomerValues : CustomerValues
initCustomerValues =
    CustomerValues Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing Nothing


type alias CustomerData =
    { id : NodeId
    , access : CustomerAccess
    , values : CustomerValues
    }


initCustomerData : CustomerData
initCustomerData =
    CustomerData "" initCustomerAccess initCustomerValues


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
