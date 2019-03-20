const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  scalar Dollars
  scalar ProductCode

  type DiscountInfo {
    discountAmount: Dollars!
    applicableProduct: ProductCode!
  }

  type Query {
    discount(code: String!): DiscountInfo
      @deprecated(reason: "Use 'discountOrError'.")
  }
`;

const resolvers = {
  Query: {
    discount: code => {
      return {
        discountAmount: 199
      };
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
