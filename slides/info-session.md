footer: incrementalelm.com
build-lists: true
slide-dividers: #

#

[.hide-footer]

![fit](img/opening.jpg)

# Agenda

- What is GraphQL?
- What is `elm-graphql`
- What would success look like in this session?
- Live demo
- Q&A

# GraphQL Intro

- Created by Facebook
- [Who's using it?](https://graphql.org/users/)
- Perfect fit for Elm
- Under-fetching & over-fetching
- The REST dance
- Graphiql
- Introspection
- Documentation navigation

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

# A Little About You

- What's your GraphQL experience?
- What's your elm experience?
- What's your elm-graphql experience?
- What would success look like in this session?

# Demo!

# Your Questions

# elm Europe Workshop!

June 26 in Paris

[>> Details](https://incrementalelm.com/)

![right original](img/workshop.jpg)

# -

![fit original](img/pagination.jpg)

# -

![](img/thank-you.jpg)
