const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  type Query {
    helloIsAnyoneHome: String
    hello: String!
    talks: [Talk!]!
  }

  type Talk {
    title: String!
    minutes: Int!
    url: String!
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

const resolvers = {
  Query: {
    helloIsAnyoneHome: maybeRespond,
    hello: maybeRespond,
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
