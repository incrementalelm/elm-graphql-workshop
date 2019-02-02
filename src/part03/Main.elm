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
    List String


query : SelectionSet Response RootQuery
query =
    Query.books booksSelection


booksSelection =
    Books.Object.Book.title


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
            { title = "Nested Selection Sets"
            , body = """Now that we're getting the titles of our books, we'd like to get the authors, too! But we also want to practice taking *tiny steps*! Why? Because small steps is what let's us move quickly, steadily, and without mistakes! It might seem unnecessary now, but having this skill at your fingertips is what will make you a master Elm GraphQL query builder!

| List
    -> Change the {Code|type alias} for {Code|Book} to be a record with a *single field in it*.
    (?) What's the benefit of starting with this step?
"""
            }
        }
