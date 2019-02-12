module Main exposing (main)

import Browser
import ElmStuff.Object
import ElmStuff.Object.Author
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
    ()


query : SelectionSet Response RootQuery
query =
    SelectionSet.empty


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://localhost:4000/"
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
            { title = "Understanding GraphQL"
            , body = """Let's get familiar with {Code|Graphiql}, a tool for building and executing GraphQL requests.

| Header
    Graph*QL*

| List
    -> Get the {Code|title} for each of my {Code|favoritePackages}

| Header
    *Graph*QL


| List
    -> Add the {Code|name}s for each {Code|author} to the previous query
    -> Now get the titles of all packages by each author from {Code|favoritePackages}. *Hint*: review the schema diagram below if you get stuck.
    (?) What are some other examples of data you could request by traversing relations like this, taking advantage of the /graph/ part of GraphQL?

<>
<>
| Image
    src = /slides/img/query3.jpg
    description = Partial schema diagram"""
            }
        }
