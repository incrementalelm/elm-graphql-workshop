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
            { title = "Nested Selection Sets"
            , body = """Wow, that's a lot of {Code|()}'s! Unless you can scan a screen as fast as Commander Data from Star Trek, you probably don't find those too interesting. But it does represent something interesting. The total number of Elm 0.19 packages!


Let's use a new tool to turn our returned data into something meaningful. Instead of getting the raw data and then doing something with it, we often prefer to get the data into exactly the meaningful data structure we want with no intermediary format. This is exactly where mapping comes in!


| Blockquote
    SelectionSet.map takes a function and a SelectionSet and calls that function on whatever data comes back in that SelectionSet.

| List
    (?) Look at the type signature in the docs for {Code|SelectionSet.map}. What does it tell you?
    -> Using {Code|SelectionSet.map}, change the top-level {Code|SelectionSet} to give us the count of all packages. Note that the type of {Code|Response} will change {Code|Int} instead of a {Code|List ()}.


Now that we're getting the titles of our books, we'd like to get the authors, too! But we also want to practice taking *tiny steps*! Why? Because small steps is what let's us move quickly, steadily, and without mistakes! It might seem unnecessary now, but having this skill at your fingertips is what will make you a master Elm GraphQL query builder!

| List
    -> Change the {Code|type alias} for {Code|ElmStuff} to be a record with a *single field in it*. Hint: you'll need to use a function called {Code|SelectionSet.map}.
    (?) What's the benefit of starting with this step?
"""
            }
        }
