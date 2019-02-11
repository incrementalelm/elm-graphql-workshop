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

^ - Introduce GraphQL Playground

^ - Sometimes null

# Nullability

```haskell
type Query {
  helloIsAnyoneHome: String
  hello: String!
}
```

^ - What does GraphQL buy you?

^ - Single end point

^ - Free docs

^ - Built-in vs. ad-hoc type checking.

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

# Scalars Are Leaves

- Enum
- String
- Int
- Float
- Boolean
- ID

^ - More on custom scalars later.

# Objects

```haskell
type Package {
  name: String!
  versions: [String!]!
}
```

^ - Not a Leaf

# Graph _QL_

```haskell
query {
  talks {
    title
    minutes
  }
}
```

#### [`run`](http://localhost:4000/?query=query%20%7B%0A%20%20talks%20%7B%0A%20%20%20%20title%0A%20%20%20%20minutes%0A%20%20%7D%0A%7D)

^ - Unlike REST, explicitly get all fields

# /Graph/ QL

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
