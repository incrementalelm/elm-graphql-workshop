module Main exposing (main)

import Browser
import ElmGithub.Object.Author
import ElmGithub.Object.Package
import ElmGithub.Object.Repository
import ElmGithub.Object.StargazerConnection
import ElmGithub.Query as Query
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import Time


type alias Response =
    List Package


query : SelectionSet Response RootQuery
query =
    -- Query.favoritePackages packageSelection
    Query.packagesByAuthor { author = "elm-community" } packageSelection
        |> SelectionSet.map (List.sortBy .stargazers)
        |> SelectionSet.map List.reverse


type alias Package =
    { stargazers : Int
    , title : String
    , author : String
    }


packageSelection =
    SelectionSet.map3 Package
        stargazerCount
        ElmGithub.Object.Package.title
        (ElmGithub.Object.Package.author ElmGithub.Object.Author.name)


stargazerCount =
    ElmGithub.Object.Package.repository <|
        ElmGithub.Object.Repository.stargazers identity
            ElmGithub.Object.StargazerConnection.totalCount


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
            { title = "Tying It All Together"
            , body = """Have some fun with this API!
| List
    -> Order the packages under the "elm-community" organization by the number of Github stars.
"""
            }
        }
