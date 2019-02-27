module Main exposing (main)

import Browser
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
            { title = "You're All Set! 🎉"
            , body = """You may want to ensure that your editor setup is working well. Otherwise, you're all set to go!

| Header
    Editor Checklist

See our {Link|editor setup guide| url = https://incrementalelm.com/learn/editor-config } for how to set up Atom with these features.

| List
    - You get code completion (example: type {Code|List.m} and you should see {Code|List.map} as a suggestion).
    - Inline Errors - try adding a top-level definition of {Code|foo = bar}. If you get an error in your editor, it makes it much easier to fix errors because you don't have to go back and forth."""
            }
        }
