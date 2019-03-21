module Main exposing (main)

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import Temperature exposing (Temperature)
import Time
import WeatherCustomScalars.Object
import WeatherCustomScalars.Object.CurrentWeather as CurrentWeather
import WeatherCustomScalars.Query as Query
import WeatherCustomScalars.Scalar as Scalar


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
            worldRecordHighInCelsius - currentTemperature
    in
    { today = currentTemperature
    , hottestDay = worldRecordHighInCelsius
    , comparison = describeDifference difference
    }


describeDifference : Float -> String
describeDifference difference =
    if difference >= 0 then
        String.fromFloat difference ++ " C cooler than the hottest ever recorded temperature."

    else
        "😅🔥 Hmm, is it really " ++ String.fromFloat -difference ++ " C hotter than the hottest day ever right now?"


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


worldRecordHighInCelsius : Float
worldRecordHighInCelsius =
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

Let's bring in some Semantic Types using our custom scalars! When I say Semantic Type, I just mean wrapping a primitive like a {Code|Float} using an Opaque Type. What's an Opaque Type?

| Blockquote
    Opaque Types: a Custom Type in Elm which doesn't expose its Constructor so it can't be Constructed or Deconstructed (Pattern Matched) except through functions defined by that module itself.

For example, you could have {Code|type Currency = Currency Int} where the {Code|Int} represents cents. At the top of the module, you would have {Code|module Currency exposing (Currency, fromCents, toCents)} (not {Code|Currency(..)}, which would publicly expose the constructor). If your internal representation changes, the public interface can stay the same.

| Header
    Using Our Own Semantic Type

Let's try using one! Instead of a {Code|Currency} type, we'll be using an Opaque Type called {Code|Temperature}.

*Don't worry about the bug quite yet*. We'll get to that in the next section.

| List
    -> Take a look at {Code|src//Temperature.elm}. It exposes an Opaque Type for representing {Code|Temperature}, which you can build with {Code|fromCelsius} or {Code|fromFahrenheit}.
    -> Change this line {Code|worldRecordHighInCelsius : Float} to {Code|worldRecordHigh : Temperature}. We're wrapping the {Code|Float} primitive in a Semantic Type, and we're changing the constant's name to reflect that ({Code|InCelsius} doesn't make sense now that it's a temperature). Now use {Code|fromCelsius} and {Code|toCelsius} in the appropriate places to get the code compiling again.


| Header
    Fixing the Bug


| List
    -> Open up {Code|server\\/weather\\-custom\\-scalars.js} and take a look at the schema. If you haven't figured it out already, you can see the cause of the bug in the schema definition. Do not change the units on the server-side. Instead, we'll just be using a Custom Scalar to make the units explicit.
    -> Add a new line to the schema string like this: {Code|scalar Fahrenheit}. Change {Code|temperature: Float!} to {Code|temperature: Fahrenheit!}. The server will automatically restart.
    -> Regenerate the code by going to the top-level workshop directory and running {Code|npx elm\\-graphql http:\\/\\/localhost:4000\\/api \\-\\-output gen \\-\\-base WeatherCustomScalars}.
    -> When you recompile your code, you'll get an error. Instead of a Float, you now have a {Code|Fahrenheit} type wrapper. Create a function with the following signature, and use it to do a {Code|SelectionSet.map} to get your code compiling. {Code|fahrenheitToFloat (Scalar.Fahrenheit degreesF) = String.toFloat degreesF \\|> Maybe.withDefault 0.0}. You'll need to use that function like this {Code|\\|> SelectionSet.map fahrenheitToFloat}.
    -> That's a good first step, and we could go ahead and convert it to celsius and fix our bug right here. But it's a good practice to defer unwrapping Semantic Types until the last possible moment. So change the type signature of your function to {Code|fahrenheitToTemperature : Scalar.Fahrenheit -> Temperature} and fix the compiler errors."""
            }
        }
