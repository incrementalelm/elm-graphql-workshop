port module Helpers.Main exposing (Program, document)

import Browser
import DateFormat exposing (text)
import Html exposing (Html, a, div, h1, input, label, p, pre, text)
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick)
import PrintAny
import Regex


port setQuery : String -> Cmd msg


type alias Program flags subModel subMsg =
    Platform.Program flags (Model subModel) (Msg subMsg)


type Msg subMsg
    = ToggleAliases
    | SubMsg subMsg


type alias Model subModel =
    { subModel : subModel
    , hideAliases : Bool
    }


document :
    { init : flags -> ( subModel, Cmd subMsg )
    , update : subMsg -> subModel -> ( subModel, Cmd subMsg )
    , queryString : String
    }
    -> Program flags subModel subMsg
document { init, update, queryString } =
    Browser.element
        { init = mapInit queryString init
        , update = mapUpdate queryString update
        , subscriptions = \_ -> Sub.none
        , view = view queryString
        }


mapInit : String -> (flags -> ( subModel, Cmd subMsg )) -> flags -> ( Model subModel, Cmd (Msg subMsg) )
mapInit queryString subInit flags =
    subInit flags
        |> Tuple.mapFirst (\subModel -> { subModel = subModel, hideAliases = True })
        |> Tuple.mapSecond (Cmd.map SubMsg)
        |> Tuple.mapSecond
            (\cmd ->
                Cmd.batch
                    [ cmd
                    , setQuery
                        (queryString |> stripAliases)
                    ]
            )



-- |> Tuple.mapSecond (Cmd.map (\current -> Cmd.batch [ current ]))


mapUpdate : String -> (subMsg -> subModel -> ( subModel, Cmd subMsg )) -> Msg subMsg -> Model subModel -> ( Model subModel, Cmd (Msg subMsg) )
mapUpdate rawQuery subUpdate msg model =
    case msg of
        ToggleAliases ->
            let
                newHideAliases =
                    not model.hideAliases
            in
            ( { model | hideAliases = not model.hideAliases }, setQuery (queryValue rawQuery newHideAliases) )

        SubMsg subMsg ->
            let
                ( a, b ) =
                    subUpdate subMsg model.subModel
            in
            ( { model | subModel = a }, b |> Cmd.map SubMsg )


view : String -> Model a -> Html (Msg subMsg)
view query model =
    div []
        [ p [] [ toggleAliasesCheckbox ]
        , div []
            [ h1 [] [ text "Elm Response" ]
            , model.subModel |> PrintAny.view
            ]
        ]


queryValue : String -> Bool -> String
queryValue rawQuery hideAliases =
    if hideAliases then
        rawQuery
            |> stripAliases

    else
        rawQuery


toggleAliasesCheckbox : Html (Msg subMsg)
toggleAliasesCheckbox =
    label []
        [ input [ type_ "checkbox", onClick ToggleAliases ] []
        , text " Show Aliases "
        , a [ href "https://github.com/dillonkearns/elm-graphql/blob/master/FAQ.md#how-do-field-aliases-work-in-dillonkearnselm-graphql" ]
            [ text "(?)"
            ]
        ]


stripAliases : String -> String
stripAliases query =
    query
        |> Regex.replace
            (Regex.fromStringWith { multiline = True, caseInsensitive = True } "^(\\s*)\\w+: "
                |> Maybe.withDefault Regex.never
            )
            (\match -> match.submatches |> List.head |> Maybe.withDefault Nothing |> Maybe.withDefault "")
