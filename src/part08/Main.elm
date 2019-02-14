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
import WeatherOptionalArgs.Enum.TemperatureUnit
import WeatherOptionalArgs.Object
import WeatherOptionalArgs.Object.CurrentWeather as CurrentWeather
import WeatherOptionalArgs.Query as Query


type alias Response =
    CurrentWeather


query : SelectionSet Response RootQuery
query =
    -- you can use weatherSelection
    -- you'll need to figure out which required arguments to pass in
    SelectionSet.succeed hardcodedWeather


weatherSelection : SelectionSet CurrentWeather WeatherOptionalArgs.Object.CurrentWeather
weatherSelection =
    SelectionSet.map5 CurrentWeather
        CurrentWeather.temperature
        CurrentWeather.city
        CurrentWeather.country
        CurrentWeather.lat
        CurrentWeather.lon



{- you can delete hardcodedWeather -}


hardcodedWeather : CurrentWeather
hardcodedWeather =
    { temperature = 123.45
    , city = "ABC"
    , country = "XYZ"
    , lat = 456.0
    , lon = 789.0
    }


type alias CurrentWeather =
    { temperature : Float
    , city : String
    , country : String
    , lat : Float
    , lon : Float
    }


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
            { title = "Optional Arguments"
            , body = """The schema has changed to use a default argument for units. This exercise is going to look exactly like the last one, except that you'll be using an optional argument in one spot.


| List
    (?) Take a look at the schema in the docs explorer. What are the pros and cons of the new design, using an optional arg for units?
    -> Take the smallest possible step to change the hardcoded data to retrieve actual data. Based on the type signature of {Code|currentWeather}, how do you pass in no optional arguments?
    -> Now that you're fetching some data with the default unit, pass in an optional argument to say you want to use {Code|Fahrenheit} instead of the default units.

| Header
    Annotations

Sometimes you will have some logic around supplying optional arguments, or you'll want to re-use or abstract optional arguments. Let's try.

| List
    -> Extract the optional arguments function into a top-level function.
    -> Add a type annotation. There is a type alias provided  by the generated code."""
            }
        }
