const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  type Query {
    helloIsAnyoneHome: String
    hello: String!
  }
`;

const responses = [
  "Coming...",
  "One sec, I'll be right there!",
  "Who is it?",
  "Hello?"
];

function maybeRespond() {
  if (Math.random() >= 0.5) {
    return randomResponse();
  }
}

function randomResponse() {
  return responses[Math.floor(Math.random() * responses.length)];
}

const resolvers = {
  Query: {
    helloIsAnyoneHome: maybeRespond,
    hello: maybeRespond
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
