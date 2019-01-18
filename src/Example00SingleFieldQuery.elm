module Example00SingleFieldQuery exposing (main)

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



{-

   The `query` definition in our Elm code
   is selecting a single top-level field, `hello`.
   The generated schema (generated by https://npmjs.com/package/@dillonkearns/elm-graphql)
   is aware that the type it will return is a
   `String` if it succeeds, hence the type annotation.

   query {
     hello
   }

-}


type alias Response =
    List String


query : SelectionSet Response RootQuery
query =
    Query.books Books.Object.Book.author


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
        }
