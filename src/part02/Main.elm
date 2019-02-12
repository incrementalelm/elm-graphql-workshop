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
    String


query : SelectionSet Response RootQuery
query =
    Query.randomQuote


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
            , body = """As we learned in the previous section, a {Code|SelectionSet} is just a group of 0 or more fields.

| Blockquote
    elm-graphql SelectionSets: A group of 0 or more Fields.

| List
    (?) How do {Code|elm-graphql} {Code|SelectionSet}s differ from GraphQL Selection Sets?


If a Field is a primitive type (like the {Code|randomQuote} field which had type {Code|String!}), then it's a leaf. But some Fields return {Code|Objects} instead of data. In these cases, we need to say which fields to get from that Object. In other words, we need to pass in a nested {Code|SelectionSet}.

As in the last exercise, we start out with {Code|SelectionSet.empty}.

| List
    -> Replace {Code|Query.randomQuote} with a Query calling {Code|allPackages}. Use {Code|SelectionSet.empty} for the nested {Code|SelectionSet}.
    (?) What use might {Code|SelectionSet.empty} have in a real-world project?
    (?) How do the type signatures compare for the top-level query and the nested selection?
    (?) What would fetching books look like in a REST API?


Now let's specify the details we want for each Elm {Code|Package}.


| List
    -> Instead of {Code|SelectionSet.empty}, get the {Code|title} of each {Code|Package}.


Taking tiny steps is essential to moving quickly and building up maintainable code. We want to fetch more than just the Package's {Code|title}. But in order to take the quickest path to the */next compiling state/*, our first step fetching one Field is a great start.
"""
            }
        }
