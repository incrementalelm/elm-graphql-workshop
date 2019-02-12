const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
const _ = require("lodash");

const key = "4a6d4fbbebab4dbdb91151515191202";

let cachedWeather = null;

const typeDefs = gql`
  type Query {
    currentWeather: CurrentWeather!
  }

  type CurrentWeather {
    temperature: Float!
    location: Location!
  }

  type Location {
    city: String!
    country: String!
    lat: Float!
    lon: Float!
    tz_id: String!
  }
`;
const CURRENT_WEATHER_URL = "http://api.apixu.com/v1/current.json";
const resolvers = {
  Query: {
    currentWeather: () => {
      if (!cachedWeather) {
        cachedWeather = get(CURRENT_WEATHER_URL, { q: "Oslo" });
      }
      return cachedWeather;
    }
  },
  CurrentWeather: {
    temperature: response => response.current.temp_c,
    location: response => response.location
  },
  Location: {
    city: location => location.name
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
