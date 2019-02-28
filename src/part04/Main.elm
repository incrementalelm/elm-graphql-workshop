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
            { title = "Combining Selection Sets"
            , body = """Let's combine the skills we've learned in order to /combine/ some {Code|SelectionSet}s together! What do I mean by combining {Code|SelectionSet}s? Well, it's actually nearly exactly the same as what we learned with {Code|SelectionSet.map}.

The only difference is that instead of applying a function to the data that comes back from a single {Code|SelectionSet}, this time you will be applying a function to the data from /two/ different {Code|SelectionSet}s!

| List
    (?) Look at the package docs to find the type signature for {Code|SelectionSet.map2}. This function will be your main tool for this exercise. How does it compare with {Code|SelectionSet.map}?

| Header
    Programming by Intention

| List
    (?) Before you begin: how can you make this task easier on yourself using the techniques for keeping things compiling at each tiny step? What would you wish into existence to make your life easier?
    -> Define the top-level {Code|query} in {Code|Main.elm} to be the percentage of Elm packages which were written by the authors of my favorite Elm packages. For example, if my favorite Elm package authors had written a combined total of 10 packages, and there were a total 100 Elm packages, the answer would be {Code|10%}. You can refer back to previous exercises if it's helpful."""
            }
        }
