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
    List ElmPackage


query : SelectionSet Response RootQuery
query =
    Query.allPackages elmPackageSelection


type alias ElmPackage =
    ()


elmPackageSelection : SelectionSet ElmPackage ElmStuff.Object.Package
elmPackageSelection =
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
            , body = """To get {Code|Book}s we need to specify what details we want for each {Code|Book}. As in the last exercise, we start out with {Code|SelectionSet.empty}.


| List
    - What use might {Code|SelectionSet.empty} have in a real-world project?
    - How do the type signatures compare for the top-level query and the nested selection?
    - What would fetching books look like in a REST API?


Taking tiny steps is essential to moving quickly and building up maintainable code. We want to fetch both the {Code|title} and {Code|author}, but in order to take the quickest path to the */next compiling state/*, we're going to start with just one.


| List
    -> Modify {Code|Main.elm} to get each {Code|Book}'s {Code|title}.
"""
            }
        }
