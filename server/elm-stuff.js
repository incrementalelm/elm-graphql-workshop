const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
let packages = require("./elm-package-cache.json");

const quotes = [
  "Be kind.",
  "Learn from everyone.",
  "Collaboration requires communication.",
  "Not every problem should be solved with code.",
  "Communication _is_ contribution.",
  "Understand the problem.",
  "Explore all possible solutions.",
  "Pick one.",
  "Simplicity is not just for beginners.",
  "It's better to do it _right_ than to do it _right now_.",
  "It's not done until the docs are great.",
  "Take responsibility for user experiences.",
  "Make impossible states impossible.",
  "There are worse things than being explicit."
];

const talks = [
  {
    title: "Making Impossible States Impossible",
    minutes: 25,
    url: "https://www.youtube.com/watch?v=IcgmSRJHu_8"
  },
  {
    title: "The Life of a File",
    minutes: 47,
    url: "https://www.youtube.com/watch?v=XpDsk374LDE"
  },
  {
    title: "Scaling Elm Apps",
    minutes: 59,
    url: "https://www.youtube.com/watch?v=DoA4Txr4GUs"
  }
];

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
  type Query {
    allPackages: [Package!]!
    packagesByAuthor(author: String!): [Package!]!
    findPackage(author: String!, name: String!): Package
    randomQuote: String!
    talks: [Talk!]!
  }

  type Package {
    name: String!
    summary: String!
    versions: [String!]!
  }

  type Talk {
    title: String!
    minutes: Int!
    url: String!
  }
`;

const resolvers = {
  Query: {
    allPackages: () => packages,
    packagesByAuthor: (parent, args, context) => {
      return packages.filter(package => {
        if (package) {
          return package.name.startsWith(`${args.author}/`);
        } else {
          return false;
        }
      });
    },
    randomQuote: () => {
      return quotes[Math.floor(Math.random() * quotes.length)];
    },
    talks: () => talks
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
