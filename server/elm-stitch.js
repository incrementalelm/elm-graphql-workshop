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
  type Query {
    allPackages: [Package!]!
    packagesByAuthor(author: String!): [Package!]!
    findPackage(author: String!, name: String!): Package
    favoritePackages: [Package!]!
  }

  type Package {
    author: Author!
    title: String!
    summary: String!
    versions: [String!]!
    url: String!
  }

  type Author {
    name: String!
    packages: [Package!]!
  }
`;

function packageByFullName(fullPackageName) {
  return packages.find(package => {
    if (package) {
      return package.name === fullPackageName;
    } else {
      return false;
    }
  });
}

function packagesByAuthor(authorName) {
  return packages.filter(package => {
    if (package) {
      return package.name.startsWith(`${authorName}/`);
    } else {
      return false;
    }
  });
}
const resolvers = {
  Query: {
    allPackages: () => packages,
    packagesByAuthor: (parent, args, context) => packagesByAuthor(args.author),
    favoritePackages: () => {
      return [
        "mdgriffith/elm-ui",
        "krisajenkins/remotedata",
        "dillonkearns/elm-graphql",
        "elm/time",
        "lukewestby/elm-http-builder",
        "terezka/line-charts"
      ].map(packageByFullName);
    }
  },
  Package: {
    author: parent => parent.name.split("/")[0],
    title: parent => parent.name.split("/")[1],
    url: parent =>
      `https://package.elm-lang.org/packages/${parent.name}/latest/`
  },
  Author: {
    name: authorName => authorName,
    packages: authorName => packagesByAuthor(authorName)
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
