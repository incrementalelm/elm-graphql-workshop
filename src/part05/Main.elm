module Main exposing (main)

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import Time
import Weather.Object.CurrentWeather
import Weather.Query as Query


type alias Response =
    String


query : SelectionSet Response RootQuery
query =
    SelectionSet.map2 difference
        (weatherFor "Santa Barbara")
        (weatherFor "Oslo")


hottestDayInCelsius =
    237.38


difference city1 city2 =
    "It is "
        ++ String.fromFloat (hottestDayInCelsius - city1)
        ++ "° (celsius) colder than the hottest recorded temperature"


weatherFor cityName =
    Query.currentWeatherByCityName
        identity
        { name = cityName }
        Weather.Object.CurrentWeather.temp


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)



-- Elm Architecture Setup


type Msg
    = GotResponse Model


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )


main : Helpers.Main.Program Flags Model Msg
main =
    Helpers.Main.document
        { init = init
        , update = update
        , queryString = Document.serializeQuery query
        , instructions =
            { title = "Combining Selection Sets"
            , body = """"""
            }
        }
