const { ApolloServer, gql } = require("apollo-server");

const typeDefs = gql`
  scalar Dollars
  scalar ProductCode

  type DiscountInfo {
    discountAmount: Dollars!
    applicableProduct: ProductCode!
  }

  union DiscountInfoOrError = DiscountInfo | DiscountLookupError

  type DiscountLookupError {
    reason: DiscountLookupReason!
  }

  enum DiscountLookupReason {
    NotFound
  }

  type Query {
    discount(code: String!): DiscountInfo
      @deprecated(reason: "Use 'discountOrError'.")
    discountOrError(code: String!): DiscountInfoOrError!
  }
`;

const resolvers = {
  Query: {
    discount: code => {
      return {
        discountAmount: 199
      };
    },
    discountOrError: code => {
      if (code === "abc") {
        return {
          discountAmount: 199
        };
      } else {
        return {
          reason: "NotFound"
        };
      }
    }
  },
  DiscountInfoOrError: {
    __resolveType(discountResponse, context, info) {
      if (discountResponse.reason) {
        return "DiscountLookupError";
      } else if (discountResponse.discountAmount) {
        return "DiscountInfo";
      } else {
        return null;
      }
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
