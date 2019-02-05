-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Weather.Object.FiveDayForecastElement exposing (clouds, dt, dtText, groundLevelPressure, humidity, pressure, rain, seaLevelPressure, snow, temp, tempMax, tempMin, weather, wind)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Weather.InputObject
import Weather.Interface
import Weather.Object
import Weather.Scalar
import Weather.ScalarDecoders
import Weather.Union


{-| -}
dt : SelectionSet (Maybe String) Weather.Object.FiveDayForecastElement
dt =
    Object.selectionForField "(Maybe String)" "dt" [] (Decode.string |> Decode.nullable)


{-| -}
weather : SelectionSet decodesTo Weather.Object.Weather -> SelectionSet (Maybe (List (Maybe decodesTo))) Weather.Object.FiveDayForecastElement
weather object_ =
    Object.selectionForCompositeField "weather" [] object_ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)


{-| -}
clouds : SelectionSet decodesTo Weather.Object.Clouds -> SelectionSet (Maybe decodesTo) Weather.Object.FiveDayForecastElement
clouds object_ =
    Object.selectionForCompositeField "clouds" [] object_ (identity >> Decode.nullable)


{-| -}
wind : SelectionSet decodesTo Weather.Object.Wind -> SelectionSet (Maybe decodesTo) Weather.Object.FiveDayForecastElement
wind object_ =
    Object.selectionForCompositeField "wind" [] object_ (identity >> Decode.nullable)


{-| -}
rain : SelectionSet decodesTo Weather.Object.Rain -> SelectionSet (Maybe decodesTo) Weather.Object.FiveDayForecastElement
rain object_ =
    Object.selectionForCompositeField "rain" [] object_ (identity >> Decode.nullable)


{-| -}
snow : SelectionSet decodesTo Weather.Object.Snow -> SelectionSet (Maybe decodesTo) Weather.Object.FiveDayForecastElement
snow object_ =
    Object.selectionForCompositeField "snow" [] object_ (identity >> Decode.nullable)


{-| -}
dtText : SelectionSet (Maybe String) Weather.Object.FiveDayForecastElement
dtText =
    Object.selectionForField "(Maybe String)" "dtText" [] (Decode.string |> Decode.nullable)


{-| -}
temp : SelectionSet Float Weather.Object.FiveDayForecastElement
temp =
    Object.selectionForField "Float" "temp" [] Decode.float


{-| -}
tempMin : SelectionSet Float Weather.Object.FiveDayForecastElement
tempMin =
    Object.selectionForField "Float" "tempMin" [] Decode.float


{-| -}
tempMax : SelectionSet Float Weather.Object.FiveDayForecastElement
tempMax =
    Object.selectionForField "Float" "tempMax" [] Decode.float


{-| -}
pressure : SelectionSet Float Weather.Object.FiveDayForecastElement
pressure =
    Object.selectionForField "Float" "pressure" [] Decode.float


{-| -}
seaLevelPressure : SelectionSet Float Weather.Object.FiveDayForecastElement
seaLevelPressure =
    Object.selectionForField "Float" "seaLevelPressure" [] Decode.float


{-| -}
groundLevelPressure : SelectionSet Float Weather.Object.FiveDayForecastElement
groundLevelPressure =
    Object.selectionForField "Float" "groundLevelPressure" [] Decode.float


{-| -}
humidity : SelectionSet Float Weather.Object.FiveDayForecastElement
humidity =
    Object.selectionForField "Float" "humidity" [] Decode.float