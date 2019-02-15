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
import WeatherCustomScalars.Object
import WeatherCustomScalars.Object.CurrentWeather as CurrentWeather
import WeatherCustomScalars.Query as Query


type alias Response =
    WeatherComparison


query : SelectionSet Response RootQuery
query =
    Query.currentWeather { city = "Accra" } CurrentWeather.temperature
        |> SelectionSet.map compareToHottestDay


type alias WeatherComparison =
    { today : Float
    , hottestDay : Float
    , comparison : String
    }


compareToHottestDay : Float -> WeatherComparison
compareToHottestDay currentTemperature =
    let
        difference =
            hottestDayInCelsius - currentTemperature
    in
    { today = currentTemperature
    , hottestDay = hottestDayInCelsius
    , comparison = String.fromFloat difference ++ " C cooler than the hottest ever recorded temperature."
    }


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


hottestDayInCelsius : Float
hottestDayInCelsius =
    56.7



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
            { title = "Custom Scalars"
            , body = """Hmm, something seems off with this code...

Let's bring in some semantic types using our custom scalars!

| Blockquote
    Opaque Types: a Custom Type in Elm which doesn't expose its Constructor so it can't be Constructed or Deconstructed (Pattern Matched) except through functions defined by that module itself.

| List
    -> Create a module called {Code|Temperature} under the {Code|src} folder. In it, expose an Opaque Type called {Code|Temperature}. It should have a function called...
    -> Wrap {Code|hottestDayInCelsius} in a Custom Type Wrapper, {Code|Celsius}. Use the wrapper for
    -> Change the schema for this server to change it from a {Code|Float} to a Custom Scalar representing its units.

| List
    -> Grab the {Code|updatedAt} time in addition to the current data being fetched.
    -> Install {Code|rtfeldman\\/elm-iso8601-date-strings} by running an {Code|elm install} command from the top-level workshop repo directory.   -> Also install {Code|sporto\\/time-distance}
    -> Use {Code|rtfeldman\\/elm-iso8601-date-strings} to parse the {Code|updatedAt} time, and {Code|sporto\\/time-distance} to map it into a human readable string like "30 seconds ago".
"""
            }
        }
