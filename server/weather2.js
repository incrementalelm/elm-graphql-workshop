const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
const _ = require("lodash");

const key = "4a6d4fbbebab4dbdb91151515191202";

let cachedWeather = null;

const typeDefs = gql`
  type Query {
    currentWeather(city: String!, units: TemperatureUnit!): CurrentWeather!
  }

  enum TemperatureUnit {
    Fahrenheit
    Celsius
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

let units;

const CURRENT_WEATHER_URL = "http://api.apixu.com/v1/current.json";
const resolvers = {
  Query: {
    currentWeather: (parent, args) => {
      units = args.units;
      if (!cachedWeather) {
        cachedWeather = get(CURRENT_WEATHER_URL, { q: args.city });
      }
      return cachedWeather;
    }
  },
  CurrentWeather: {
    temperature: response => {
      if (units === "Fahrenheit") {
        return response.current.temp_f;
      } else if (units === "Celsius") {
        return response.current.temp_c;
      } else {
        throw new Error(`Unknown unit ${units}`);
      }
    },
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

function get(url, queries = {}) {
  const queryString = _.chain({ ...queries, key })
    .toPairs()
    .map(p => p.join("="))
    .join("&")
    .value();
  const getUrl = `${url}?${queryString}`;
  return axios.get(getUrl).then(({ data }) => data);
}

const server = new ApolloServer({
  typeDefs,
  resolvers
});

server.listen().then(({ url }) => {
  console.log(`🚀  Server ready at ${url}`);
});
