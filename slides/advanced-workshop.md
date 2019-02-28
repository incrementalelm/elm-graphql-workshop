footer: incrementalelm.com
build-lists: true
slide-dividers: #

#

[.hide-footer]

![fit](img/opening.jpg)

# Setup

github.com/IncrementalElm/elm-graphql-workshop

# Custom Scalars

- What is the purpose of a scalar?
  - `Date`
  - `DateTime`
  - `GitObjectID`
  - `HTML`
  - `URI`
  - `DateTime`: "An ISO-8601 encoded UTC date string."

# Custom Scalars Are Contracts

- Custom Scalar type wrappers by default
  - `type alias DateTime = DateTime String`
- Isn't that just a fancy `String`?
- Yup! Type-wise...
- Semantically, it's an ISO-8601 DateTime
- Contracts => Serializer/Deserializer

# Exercise 09 - Custom Scalars

```bash
./run.sh src/part09
```

# Exercise 10 - Imperfect Schemas

```bash
./run.sh src/part10
```

# [Polymorphism in GraphQL](http://elm-graphql.herokuapp.com)

```haskell
interface Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
}
```

```haskell
type Human implements Character {
  id: ID!
  name: String!
  friends: [Character!]!
  homePlanet: String!
}

type Droid implements Character {
  id: ID!
  name: String!
  friends: [Character!]!
  primaryFunction: String!
}
```

# Polymorphism in Elm GraphQL

```elm
type alias HumanOrDroidWithName =
    { name : String
    , details : HumanOrDroidDetails
    }

heroSelection : SelectionSet HumanOrDroidWithName Swapi.Interface.Character
heroSelection =
    SelectionSet.map2 HumanOrDroidWithName
        Character.name
        (Character.fragments
            { onHuman = SelectionSet.map HumanDetails Human.homePlanet
            , onDroid = SelectionSet.map DroidDetails Droid.primaryFunction
            }
```

^ Unlike GraphQL, you can guarantee an exhaustive fragment

# Non-Exhaustive Fragments

```elm
nonExhaustiveFragment : SelectionSet (Maybe String) Swapi.Union.CharacterUnion
nonExhaustiveFragment =
    let
        maybeFragments =
            Swapi.Union.CharacterUnion.maybeFragments
    in
    Swapi.Union.CharacterUnion.fragments
        { maybeFragments
            | onHuman = Human.homePlanet
        }
```

# Unions

- Exactly like fragments, except there are no common fields.

# Unions in Elm GraphQL

```elm
type HumanOrDroidDetails
    = HumanDetails (Maybe String)
    | DroidDetails (Maybe String)

heroUnionSelection : SelectionSet HumanOrDroidDetails Swapi.Union.CharacterUnion
heroUnionSelection =
    Swapi.Union.CharacterUnion.fragments
        { onHuman = SelectionSet.map HumanDetails Human.homePlanet
        , onDroid = SelectionSet.map DroidDetails Droid.primaryFunction
        }
```

# Up-To-Date Generated Code

- Simple CI check
- `npm run regenerate-elm-graphql && elm make ...`
- Every time before your schema goes live
- Otherwise, exhaustive checks could fail

# Data Modeling Example

JavaScript

```javascript
{
    hasError: true,
    errorMessage : 'Error message from server',
    doneLoading: true,
    data: null
}
```

---

![fit](img/remote-data-truth-table.png)

---

# RemoteData

```elm
type RemoteData data
    = NotAsked
    | Loading
    | Failure Http.Error
    | Success data
```

# Subscriptions

# Exercise 12 Tying It All Together

- Schema Stitching

```bash
./run.sh src/part12
```

# Feedback

- Anonymous Survey
  - [tiny.cc/elm-graphql-feedback](http://tiny.cc/elm-graphql-feedback)

# -

![](img/thank-you.jpg)

# -

```

```
