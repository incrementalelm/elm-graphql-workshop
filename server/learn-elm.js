const { ApolloServer, gql } = require("apollo-server");

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

const typeDefs = gql`
  type Query {
    randomQuote: String!
    talks: [Talk!]!
  }

  type Talk {
    title: String!
    minutes: Int!
    url: String!
  }
`;

const resolvers = {
  Query: {
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
