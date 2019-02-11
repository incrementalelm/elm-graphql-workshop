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

[.code-highlight: all]

[.code-highlight: 2]

```haskell
type Package {
  title: String!
  url: String!
  versions: [String!]!
}
```

# Graph _QL_

[.code-highlight: all]

[.code-highlight: 3]

[.code-highlight: 2-4]

```haskell
query {
  favoritePackages {
    title
  }
}
```

#### [`run`](http://localhost:4000/?query=query%20%7B%0A%20%20talks%20%7B%0A%20%20%20%20title%0A%20%20%20%20minutes%0A%20%20%7D%0A%7D)

^ - Unlike REST, explicitly get all fields

^ - Not a Leaf

^ - Selection Sets

# _Graph_ QL

```javascript
query {
  authors {
    elmCommunity {
      packages {
        name
      }
    }
  }
}
```

#### [`run`](http://localhost:4000/?query=%7B%0A%20%20authors%20%7B%0A%20%20%20%20elmCommunity%20%7B%0A%20%20%20%20%20%20packages%20%7B%0A%20%20%20%20%20%20%20%20name%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A)

# Mutations

^ - Just Objects

^ - Pick one: `query`, `mutation`, `subscription`

# `dillonkearns/elm-graphql`

# GraphQL Client Strategies

- No code generation
- Generate code for specific query
- Generate code for whole schema
