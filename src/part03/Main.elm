module Main exposing (main)

import Browser
import ElmStuff.Object
import ElmStuff.Object.Package
import ElmStuff.Query as Query
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import Time


type alias Response =
    List ()


query : SelectionSet Response RootQuery
query =
    Query.allPackages packageSelection


packageSelection : SelectionSet () ElmStuff.Object.Package
packageSelection =
    SelectionSet.empty


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "/api"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)



-- Elm Architecture Setup


type Msg
    = GotResponse Model


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )


main : Helpers.Main.Program Flags Model Msg
main =
    Helpers.Main.document
        { init = init
        , update = update
        , queryString = Document.serializeQuery query
        , instructions =
            { title = "Transforming Selection Sets"
            , body = """Wow, that's a lot of {Code|()}'s! Unless you can scan a screen as fast as Commander Data from Star Trek, you probably don't find those too interesting. But it does represent something interesting. The total number of Elm 0.19 packages!


Let's use a new tool to turn our returned data into something meaningful. Instead of getting the raw data and then doing something with it, we often prefer to get the data into exactly the meaningful data structure we want with no intermediary format. This is exactly where mapping comes in!


| Blockquote
    SelectionSet.map takes a function and a SelectionSet and calls that function on whatever data comes back in that SelectionSet.

| List
    (?) Look at the type signature in the docs for {Code|SelectionSet.map}. What does it tell you?
    -> Using {Code|SelectionSet.map}, change the top-level {Code|SelectionSet} to give us the count of all packages. Note that the type of {Code|Response} will change {Code|Int} instead of a {Code|List ()}.

| Header
    More Complex Maps

Now let's forget about the package names for a second. I want to scan a list of the latest version numbers. So I want to see something like this:


| Monospace

    Success
    [
      "1.0.0"
      "2.0.3"
      "1.5.0"
      "4.5.2"
    ]

This map is a bit more challenging, so let's break it down into small steps. The smaller our steps, the faster we move.

| Blockquote
    Small steps: The smaller our steps, the faster we move.

First we'll do a hardcoded mapping. So instead of real data, turn every "latest version" into a hard coded "1.2.3".

| List
    -> Create a function which maps a versions argument of type {Code|List String} into a hard coded latest version of type {Code|String}. Apply this mapping to get a long list of "1.2.3" over and over again!
    -> Now, change the hard coded "1.2.3" in your return type to be the actual "latest published package version" (i.e. the last {Code|String} in the {Code|versions} list).
    (?) What would this code look like as a series of calls to {Code|SelectionSet.map}? Which format do you prefer?
    (?) What did the hard coded mapping step do for you? What are some benefits? When would you choose to use this intermediary step, when would you not?

| Header
    Mapping Into a Record

Now that we're getting the latest version of our packages, we'd like to get some other details, too! But we also want to practice taking *tiny steps*! Why? Because small steps is what let's us move quickly, steadily, and without mistakes! It might seem unnecessary now, but having this skill at your fingertips is what will make you a master Elm GraphQL query builder!

| List
    -> Change the {Code|type alias} for {Code|ElmStuff} to be a record with a *single field in it*. Hint: you'll need to use {Code|SelectionSet.map}.
    (?) What's the benefit of starting with this step before adding more fields to our {Code|ElmStuff} record alias?
"""
            }
        }
