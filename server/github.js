const { createApolloFetch } = "apollo-fetch";

const fetcher = createApolloFetch({ uri: "https://api.github.com/graphql" });
fetcher.use(({ request, options }, next) => {
  if (!options.headers) {
    options.headers = {};
  }
  options.headers[
    "Authorization"
  ] = `Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59`;

  next();
});

export default async () => {
  const schema = makeRemoteExecutableSchema({
    schema: await introspectSchema(fetcher),
    fetcher
  });
  return schema;
};
