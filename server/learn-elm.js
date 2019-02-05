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

const typeDefs = gql`
  type Query {
    randomQuote: String!
  }
`;

const resolvers = {
  Query: {
    randomQuote: () => {
      return quotes[Math.floor(Math.random() * quotes.length)];
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
