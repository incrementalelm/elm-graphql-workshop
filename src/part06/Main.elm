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
import Weather.Object.CurrentWeather as CurrentWeather
import Weather.Query as Query


type alias Response =
    CurrentWeather


query : SelectionSet Response RootQuery
query =
    Query.currentWeather weatherSelection


type alias CurrentWeather =
    { temperature : Float
    , city : String
    , country : String
    , lat : Float
    , lon : Float
    }


weatherSelection =
    SelectionSet.map5 CurrentWeather
        CurrentWeather.temperature
        CurrentWeather.city
        CurrentWeather.country
        CurrentWeather.lat
        CurrentWeather.lon


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
            { title = "Pipelines"
            , body = """Often when working with GraphQL requests in Elm, you want to add a new field to your request. There are two different methods for adding new fields. Let's practice them both.


| Header
    Method 1: Map{Code|<n + 1>}


| List
    -> Add one more piece of data from the {Code|currentWeather} to your request by turning {Code|map5} into a {Code|map6}.
    (?) What kind of error message do you get? How precise is it?


| Header
    Pipelines

| List
    -> Convert the current {Code|map6} into a pipeline.
    -> Add one more field to the pipeline.
    (?) How does this error message compare to the {Code|mapN} message?
"""
            }
        }
