module Temperature exposing (Temperature, fromCelsius, fromFahrenheit, toCelsius, toFahrenheit)


type Temperature
    = Fahrenheit Float
    | Celsius Float


fromCelsius : Float -> Temperature
fromCelsius degreesCelsius =
    Celsius degreesCelsius


fromFahrenheit : Float -> Temperature
fromFahrenheit degreesFahrenheit =
    Fahrenheit degreesFahrenheit


toCelsius : Temperature -> Float
toCelsius temperature =
    0.0


toFahrenheit : Temperature -> Float
toFahrenheit temperature =
    0.0
