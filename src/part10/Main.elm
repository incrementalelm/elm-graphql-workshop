module Main exposing (main)

import Browser
import ElmStuffImperfect.Query as Query
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import Time


type alias Response =
    ()


query : SelectionSet Response RootQuery
query =
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
            { title = "Imperfect Schemas"
            , body = """We're going to do some familiar queries. We'll be getting the exact same data as in previous exercises, but this time using an imperfect version of the schema.

| List
    (?) Explore the API and its types in the docs sidebar. What's different?
    -> Retrieve a {Code|randomQuote}.

| Header
    Assumptions Vs. Guarantees

The goal when designing your {Code|elm-graphql} API is to allow you to /completely remove all assumptions about your API/ and replace them with /guarantees/. Having a well-designed schema and API gets you pretty close to that! But in the real-world, sometimes we don't have a perfect schema so we have to make assumptions. That's what {Link|Result or Fail transformations | url=https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-SelectionSet#result-orfail-transformations } are for.

| Blockquote
    Result or Fail Transformations: Make an assumption that isn't guaranteed by your schema. If it fails, the entire decoder fails ⚠️

Let's try it with our imperfect schema.

| List
    -> Take a look at the {Link|Result or Fail transformations | url=https://package.elm-lang.org/packages/dillonkearns/elm-graphql/latest/Graphql-SelectionSet#result-orfail-transformations } in the docs.
    -> Use one of the "Result or fail" functions to eliminate any Maybes from your returned data.
    (?) Are there any alternatives solutions that don't involve these unsafe functions? What are the tradeoffs?
    (?) When would you use these versus changing the schema?

| Header
    Imperfection Compounded

Let's try some stacked up imperfections.

| List
    -> Retrieve our {Code|favoritePackages}, and for each package get its {Code|name} and {Code|author}'s name. Make sure there are no {Code|Maybe}s anywhere in your model!


| Header
    Bonus

| List
    -> Check out a real world GraphQL API: {Link|yelp.com\\/developers\\/graphiql | url = https://www.yelp.com/developers/graphiql }. Explore the types and find some real-world imperfections.
    (?) How would you improve these imperfections?
"""
            }
        }
