module Main exposing (main)

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, hardcoded, with)
import Helpers.Main
import RemoteData exposing (RemoteData)
import ShoppingCart.Enum.DiscountLookupReason exposing (DiscountLookupReason)
import ShoppingCart.Object.DiscountInfo
import ShoppingCart.Object.DiscountLookupError
import ShoppingCart.Query as Query
import ShoppingCart.Union.DiscountInfoOrError
import Time


type alias Response =
    ()


type DiscountInfoOrError
    = DiscountInfo { discountedPrice : String }
    | DiscountLookupError { reason : DiscountLookupReason }


query : SelectionSet Response RootQuery
query =
    Query.discountOrError { code = "abc" }
        (ShoppingCart.Union.DiscountInfoOrError.fragments
            { onDiscountInfo = SelectionSet.empty
            , onDiscountLookupError = SelectionSet.empty
            }
         -- { onDiscountInfo = ShoppingCart.Object.DiscountInfo.applicableProduct
         -- , onDiscountLookupError = ShoppingCart.Object.DiscountLookupError.reason
         -- }
        )


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
            { title = "Unions"
            , body = """In GraphQL, a Union type is one of <n> different possible Objects.

| List
    -> Take a look at the docs explorer and examine the `DiscountInfoOrError` union type. Which objects could it possibly be?
    (?) What would the JSON look like for each of the possible objects returned in the `DiscountInfoOrError` union?


A Union in GraphQL is a lot like a Custom Type in elm. The equivalent of `DiscountInfoOrError` in elm would look like:

| Monospace
    type DiscountInfoOrError
      = DiscountInfo { discountedPrice : String }
      | DiscountLookupError { reason : DiscountLookupReason }


    describeInfoOrError : DiscountInfoOrError -> String
    describeInfoOrError discountInfoOrError =
      case discountInfoOrError of
        DiscountInfo { discountedPrice } ->
            "You got info"

        DiscountLookupError { reason } ->
            "You got an error"


| List
    #. turn it into a SelectionSet.empty (smallest possible steps). You should have {Code|query : SelectionSet () RootQuery}.
    #. use the two {Code|Result} constructors, {Code|Err} and {Code|Ok}, to create a {Code|query : SelectionSet (Result DiscountLookupReason Int) RootQuery}.
    #. use fragments to turn it into a data type like that.
    (?) Which solution do you like more, the {Code|Result}, or our custom type?

{Code|ShoppingCart.Union.DiscountInfoOrError.fragments}"""
            }
        }
