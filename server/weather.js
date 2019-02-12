const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
const _ = require("lodash");

const key = "4a6d4fbbebab4dbdb91151515191202";

const typeDefs = gql`
  type Query {
    currentWeather: CurrentWeather!
  }

  type CurrentWeather {
    temperature: Float!
`;
const CURRENT_WEATHER_URL = "http://api.apixu.com/v1/current.json";
const resolvers = {
  Query: {
    currentWeather: () => {
      return get(CURRENT_WEATHER_URL, { q: "Oslo" });
    }
  },
  CurrentWeather: {
    temperature: response => response.current.temp_c
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
