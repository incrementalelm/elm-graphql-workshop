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
import WeatherTwo.Enum.TemperatureUnit
import WeatherTwo.Object
import WeatherTwo.Object.CurrentWeather as CurrentWeather
import WeatherTwo.Query as Query


type alias Response =
    CurrentWeather


query : SelectionSet Response RootQuery
query =
    -- you can use weatherSelection
    -- you'll need to figure out which required arguments to pass in
    SelectionSet.succeed hardcodedWeather


weatherSelection : SelectionSet CurrentWeather WeatherTwo.Object.CurrentWeather
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
            { title = "Required Arguments"
            , body = """We're going to replace the hardcoded selection in the top-level {Code|query} with the {Code|currentWeather}. We'll learn how to use required arguments, with some tricks for finding them quickly and easily.

| List
    (?) How many arguments did the {Code|Query.currentWeather} function take before? How many should it take now?
    -> We're going to use the compiler to tell us the required arguments. Make a call to {Code|currentWeather}, supplying {Code|\\{\\}} (empty record) as the required arguments, and {Code|weatherSelection} as the {Code|SelectionSet}.
    (?) What other techniques could you use to determine the required arguments?
    -> Fix the compiler error."""
            }
        }
