const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
let packages = require("./elm-package-cache.json");

axios
  .get("https://package.elm-lang.org/search.json")
  .then(function(response) {
    packages = response.data;
  })
  .catch(function(error) {
    console.log(
      "Failed to make HTTP request to elm-lang package server.",
      error
    );
  });

const typeDefs = gql`
  type Package {
    name: String!
    summary: String!
    versions: [String!]!
  }

  type Query {
    all: [Package!]!
    byAuthor(author: String!): [Package!]!
    find(author: String!, name: String!): Package
  }
`;

const resolvers = {
  Query: {
    all: () => packages,
    byAuthor: (parent, args, context) => {
      return packages.filter(package => {
        if (package) {
          return package.name.startsWith(`${args.author}/`);
        } else {
          return false;
        }
      });
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
