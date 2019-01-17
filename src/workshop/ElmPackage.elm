module ElmPackage exposing (request)

import Http
import Json.Decode as Decode


request =
    Http.get
        { url = "/search.json"

        --        { url = "https://package.elm-lang.org/search.json"
        --        { url = "/elmpackage/search.json"
        , expect = Http.expectJson identity decoder
        }


decoder =
    Decode.list (Decode.field "name" Decode.string)
