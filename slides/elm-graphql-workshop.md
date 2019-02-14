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

# `GraphQL Field`

Data that you ask for in your query.

# Fields

```haskell
type Query {
  helloIsAnyoneHome: String
}
```

```haskell
query {
  helloIsAnyoneHome
}
```

```javascript
{
  "data": {
    "helloIsAnyoneHome": "One sec, I'll be right there!"
  }
}
```

^ #### Schema Definition Language (`SDL`)

^ #### GraphQL Query (`gql`)

^ #### Response (`JSON`)

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

# Scalars Are Leaves

- String
- Int
- Float
- Boolean
- ID
- Custom Scalars (URL, GitSha, Miles)
- Enum

^ - More on custom scalars later.

# Enums

```haskell
enum Order {
  ASCENDING
  DESCENDING
}
```

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

# -

![fit ](img/query1.jpg)

# -

![fit original](img/query1.jpg)

[.code-highlight: all]

[.code-highlight: 3]

[.code-highlight: 2-4]

<br>
<br>
<br>

``````haskell
query {
  favoritePackages {
    title
  }
}
```

#### [`run`](http://localhost:4000/?query=query%20%7B%0A%20%20favoritePackages%20%7B%0A%20%20%20%20title%0A%20%20%7D%0A%7D%0A)


^ - Unlike REST, explicitly get all fields

^ - Not a Leaf

^ - Still a field

^ - Selection Sets

# Branches Versus Leaves

`````haskell
query {
  favoritePackages {
    title
  }
}
```

^ - Must explicitly state selection for branches.

^ - Scalar fields are leaves.


# -

![fit original](img/query2.jpg)

<br>
<br>
<br>

````haskell
query {
  favoritePackages {
    title
  }
}
```

#### [`run`](http://localhost:4000/?query=query%20%7B%0A%20%20favoritePackages%20%7B%0A%20%20%20%20title%0A%20%20%7D%0A%7D%0A)

^ - Data shape matches request
# -

![fit original](img/query2.jpg)

[.code-highlight: 4]

<br>
<br>
<br>

````haskell
query {
  favoritePackages {
    title
    author { name }
  }
}
```

#### [`run`](http://localhost:4000/?query=query%20%7B%0A%20%20favoritePackages%20%7B%0A%20%20%20%20title%0A%20%20%7D%0A%7D%0A)

^ - Data shape matches request

# -

![fit ](img/query3.jpg)

# Everything Is A Field

```haskell
type Query {
  helloIsAnyoneHome: String
  hello: String!
  favoritePackages: [Package!]!
}
```

```haskell
query {
  helloIsAnyoneHome
}
```

^ - If you ask for it, it's a field.

^ - Including query.


# Mutations

```haskell
mutation {
  addTodo(description: "Learn GraphQL")
}
```

- Just Objects

- Pick one: `query`, `mutation`, `subscription`

# `dillonkearns/elm-graphql`

# Avoidable Uncertainty

![original](img/run-fix.jpg)

# With Certainty

![original](img/compile-fix.jpg)

# Types Without Borders

![original 100% right](img/types-without-borders-youtube.jpeg)


# GraphQL Client Strategies

- No code generation
- Generate code for specific query
- Generate code for whole schema


# Exercise 00

TODO: Download Link

```bash
cd /path/to/repo
npm install
./run.sh src/part00
```

[http://localhost:8000](http://localhost:8000)

# Exercise 01

Walk Before You Run

```
./run.sh src/part01
```

# Required Arguments

```haskell
type Query {
  repository(owner: String!, name: String!): Repository
}
```

```haskell
query {
  repository {
    name
  }
}
```

#### [run](https://developer.github.com/v4/explorer/?query=query%20%7B%0A%20%20repository%20%7B%0A%20%20%20%20name%0A%20%20%7D%0A%7D)

^ - What's going to happen?

^ - By the way, way is Repository nullable?

# GraphQL Arguments

```haskell
type User {
  avatarUrl(size: Int): URI!
}
```

```haskell
query {
  viewer {
    avatarUrl
  }
}
```

#### [run](https://developer.github.com/v4/explorer/?query=query%20%7B%0A%20%20viewer%20%7B%0A%20%20%20%20avatarUrl%0A%20%20%7D%0A%7D)

^ - What's going to happen?

# GraphQL Arguments

```haskell
type User {
  avatarUrl(size: Int): URI!
}
```

```haskell
query {
  viewer {
    avatarUrl(size: 48)
  }
}
```


#### [run](https://developer.github.com/v4/explorer/?query=query%20%7B%0A%20%20viewer%20%7B%0A%20%20%20%20avatarUrl(size%3A%2048\)%0A%20%20%7D%0A%7D)

# Non-Scalar Arguments

- How do you abstract a set of arguments?

# Top-Level Arguments
```haskell
type Repository {
  issues(assignee: String, createdBy: String, labels: [String!], ...)
}

type User {
  issues(assignee: String, createdBy: String, labels: [String!], ...)
}
```

# Input Objects
```haskell
input IssueFilters {
  assignee: String
  createdBy: String
  labels: [String!]
  # ...
}

type Repository {
  issues(IssueFilters)
}

type User {
  issues(assignee: String, createdBy: String, labels: [String!], ...)
}
```

- Definition: a group of scalars
- Exactly like a GraphQL Object
- Except that it can't be recursive
- Allows you to state that a group must either be there or not
- Still can't express union types fully (like one of (first,last))

# Required Argument Code Gen

```elm
currentWeather : CurrentWeatherRequiredArguments
    -> SelectionSet decodesTo Weather.Object.CurrentWeather
    -> SelectionSet decodesTo RootQuery

type alias CurrentWeatherRequiredArguments = { someArgument : String, ... }
```

# Exercise 07

```bash
./run src/part07
```

# Optional Argument Code Gen

```elm
currentWeather : (CurrentWeatherOptionalArguments -> CurrentWeatherOptionalArguments)
    -> CurrentWeatherRequiredArguments
    -> SelectionSet decodesTo Weather.Object.CurrentWeather
    -> SelectionSet decodesTo RootQuery

type alias CurrentWeatherRequiredArguments = { someArgument : String, ... }
```

- Helps to memorize this order
- Always the same
- Any argument may be missing
- How do you give no optional arguments?

# `identity`

- `a -> a`
- How would you define this function?
- Get it compiling, then get it right

# The `OptionalArgument` type

```elm
type OptionalArgument a
    = Present a
    | Absent
    | Null
```

- Why not just a Maybe?
- [`OptionalArgument` docs](https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-OptionalArgument)

# Supplying Optional Args

```elm
-- Null, Present, Absent
import Graphql.OptionalArgument exposing (OptionalArgument(..))

Query.hero (\optionals -> {optionals | episode = Present Episode.EMPIRE })
```

- Which is the default if you don't pass it in?
- [Optional Args in a Language Without Optional Args](https://medium.com/@zenitram.oiram/graphqelm-optional-arguments-in-a-language-without-optional-arguments-d8074ca3cf74)

# Exercise 08

```bash
./run src/part08
```


# Thank You!
``````
