module Temperature exposing (Temperature, fromCelsius, fromFahrenheit, toCelsius)


type Temperature
    = Celsius Float


fromCelsius : Float -> Temperature
fromCelsius degreesCelsius =
    Celsius degreesCelsius


fromFahrenheit : Float -> Temperature
fromFahrenheit degreesFahrenheit =
    Celsius ((degreesFahrenheit - 32) / 1.8)


toCelsius : Temperature -> Float
toCelsius (Celsius degreesC) =
    degreesC
