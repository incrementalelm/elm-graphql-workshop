const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  type Query {
    currentWeatherByCityName(
      name: String!
      countryCode: String
    ): CurrentWeather!
  }

  type CurrentWeather {
    coord: Coordinate
    weather: [Weather]
    wind: Wind
    clouds: Clouds
    rain: Rain
    snow: Snow
    temp: Float!
    tempMin: Float!
    tempMax: Float!
    pressure: Float!
    humidity: Float!
    """
    Sunrise time in specified location, in POSIX UTC date time format.
    """
    sunrise: Int!

    """
    Sunset time in specified location, in POSIX UTC date time format.
    """
    sunset: Int!

    """
    the current time in POSIX date time format.
    """
    dt: String
    id: Int
    name: String
    cod: String
  }
  type Rain {
    volumePast3Hours: Float
  }

  type Snow {
    volumePast3Hours: Float
  }

  type Clouds {
    all: Float
  }

  type Wind {
    speed: Float
    deg: Float
  }

  # geographic coordinate
  type Coordinate {
    # latitude
    lat: Float
    # longitude
    lon: Float
  }

  type Weather {
    id: Int
    main: String
    description: String
    icon: String
    iconURL: String
  }

  type City {
    id: Int
    name: String
    coord: Coordinate
    country: String
  }
`;

const resolvers = {
  Query: {
    currentWeatherByCityName: () => {
      return {
        temp: 123
      };
    }
  }
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  engine: process.env.ENGINE_API_KEY && {
    apiKey: process.env.ENGINE_API_KEY
  }
});

server.listen().then(({ url }) => {
  console.log(`🚀  Server ready at ${url}`);
});
