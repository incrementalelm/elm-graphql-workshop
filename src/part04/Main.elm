module Main exposing (main)

import Books.Object.Book
import Books.Query as Query
import Browser
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
            { title = "Deconstructing Constructors"
            , body = """This simple Elm concept can really trip you up if you don't take the time to fully understand it. Let's take a moment to demystify Elm constructors!

What is a constructor? Well, it's a way to build up a record.

| Blockquote
    An Elm constructor is just a function to build a record.

    The only difference it has from a regular Elm function is that it __________________.


We'll fill in that blank in a minute.

First, let's define a function manually that does this. It is functionally the same thing as an Elm Constructor. There's just one small difference between this and a real Elm constructor, which we'll get to when we fill in that blank.

| Ellie
    4BVqf9HJc7xa1


| List
    (?) What Elm things exist after you define your {Code|type alias} that didn't before?
    (?) In what context can these things be used?

| Ellie
    4BTH7sy8zRWa1

| List
    -> Try using `type alias Person = String`. Does it compile? What does Elm define in this case?
"""
            }
        }
