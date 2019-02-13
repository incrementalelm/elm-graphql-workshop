const { ApolloServer, gql } = require("apollo-server");
const axios = require("axios");
let packages = require("./elm-package-cache.json");
const {
  introspectSchema,
  makeRemoteExecutableSchema,
  FilterRootFields,
  makeExecutableSchema,
  transformSchema,
  mergeSchemas
} = require("graphql-tools");

const { setContext } = require("apollo-link-context");
const { HttpLink } = require("apollo-link-http");
const fetch = require("node-fetch");

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

const elmSchema = makeExecutableSchema({ resolvers, typeDefs });

const githubLink = setContext(request => ({
  headers: {
    Authorization: `Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59`
  }
})).concat(new HttpLink({ uri: "https://api.github.com/graphql", fetch }));

// const executableExtendedSchema = makeExecutableSchema({
//   resolvers: extendedResolvers,
//   typeDefs: extendedTypeDefs
// });

async function startServer() {
  const githubSchema = await introspectSchema(githubLink);

  const githubExecutableSchemaUnfiltered = makeRemoteExecutableSchema({
    schema: githubSchema,
    link: githubLink
  });

  const githubExecutableSchema = transformSchema(
    githubExecutableSchemaUnfiltered,
    [new FilterRootFields((operation, rootField) => rootField === "repository")]
  );

  const extendedTypeDefs = `
  extend type Package {
    repository: Repository!
  }
  `;

  const extendedResolvers = {
    Package: {
      repository: {
        fragment: "... on Package { author { name } title }",
        resolve(elmPackage, args, context, info) {
          return info.mergeInfo.delegateToSchema({
            schema: githubExecutableSchema,
            operation: "query",
            fieldName: "repository",
            args: {
              owner: elmPackage.author.name,
              name: elmPackage.title
            },
            context,
            info
          });
        }
      }
    }
  };

  const server = new ApolloServer({
    schema: mergeSchemas({
      schemas: [githubExecutableSchema, elmSchema, extendedTypeDefs],
      resolvers: extendedResolvers
    })
  });

  await server.listen().then(({ url }) => {
    console.log(`🚀  Server ready at ${url}`);
  });
}

startServer();
