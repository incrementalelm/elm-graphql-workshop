const { ApolloServer, gql } = require("apollo-server");
const { get, CURRENT_WEATHER_URL } = require("./helpers");

const key = "4a6d4fbbebab4dbdb91151515191202";

let cachedWeather = null;

const typeDefs = gql`
  type Query {
    currentWeather: CurrentWeather!
  }

  type CurrentWeather {
    temperature: Float!
    city: String!
    country: String!
    lat: Float!
    lon: Float!
    tzId: String!
    localTime: Int!
    updatedAt: Int!
    windSpeed: Float!
    windDirection: String!
  }
`;
const resolvers = {
  Query: {
    currentWeather: () => {
      if (!cachedWeather) {
        cachedWeather = get(CURRENT_WEATHER_URL, { q: "Oslo", key });
      }
      return cachedWeather;
    }
  },
  CurrentWeather: {
    temperature: response => response.current.temp_c,
    city: response => response.location.name,
    country: response => response.location.country,
    lat: response => response.location.lat,
    lon: response => response.location.lon,
    tzId: response => response.location.tz_id,
    localTime: response => response.location.localtime_epoch,
    updatedAt: response => response.current.last_updated_epoch,
    windSpeed: response => response.current.wind_kph,
    windDirection: response => response.current.wind_dir
  }
};

const server = new ApolloServer({
  typeDefs,
  resolvers
});

server.listen().then(({ url }) => {
  console.log(`🚀  Server ready at ${url}`);
});
