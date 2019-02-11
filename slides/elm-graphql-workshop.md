footer: bit.ly/**examplefirst**
build-lists: true
slide-dividers: #

#

[.hide-footer]

![fit](img/opening.jpg)

# GraphQL Concepts

- SDL (Schema Definition Language)

# Query

```haskell
type Query {
  helloIsAnyoneHome: String
}
```

# Nullability

```haskell
type Query {
  helloIsAnyoneHome: String
  hello: String!
}
```

# Objects

```haskell
type Package {
  name: String!
  summary: String!
  versions: [String!]!
}
```

# Enums

```haskell
enum Order {
  ASCENDING
  DESCENDING
}
```

# Foo

```haskell
type Query {
  hello: String
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
```
