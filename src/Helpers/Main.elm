port module Helpers.Main exposing (Program, document)

import Browser
import DateFormat exposing (text)
import Element exposing (Element)
import Element.Background
import Html exposing (Html, a, div, h1, input, label, p, pre, text)
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick)
import Instructions exposing (Instructions)
import Mark
import Mark.Default
import PrintAny
import Regex


port setupGraphiql : { query : String, response : String } -> Cmd msg


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
    , instructions : Instructions
    }
    -> Program flags subModel subMsg
document { init, update, queryString, instructions } =
    Browser.element
        { init = mapInit queryString init
        , update = mapUpdate queryString update
        , subscriptions = \_ -> Sub.none
        , view = view instructions
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
                    , setupGraphiql
                        { query = queryString |> stripAliases
                        , response = ""
                        }
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
            ( { model | hideAliases = not model.hideAliases }
            , setupGraphiql
                { query = queryValue rawQuery newHideAliases
                , response = PrintAny.asString model.subModel
                }
            )

        SubMsg subMsg ->
            let
                ( a, b ) =
                    subUpdate subMsg model.subModel
            in
            ( { model | subModel = a }
            , Cmd.batch
                [ b |> Cmd.map SubMsg
                , setupGraphiql
                    { query = queryValue rawQuery model.hideAliases
                    , response = PrintAny.asString model.subModel
                    }
                ]
            )


view : Instructions -> Model a -> Html (Msg subMsg)
view instructions model =
    Element.row
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.padding 20

        -- , Element.clip
        -- , Element.htmlAttribute (Html.Attributes.style "flex-shrink" "1")
        ]
        [ Element.column
            [ Element.width (Element.fillPortion 1)
            , Element.height Element.fill

            -- , Element.clip
            -- , Element.htmlAttribute (Html.Attributes.style "flex-shrink" "1")
            ]
            [ toggleAliasesCheckbox
            , Element.el [] (Element.text "Elm Response")

            -- , PrintAny.view model.subModel
            , PrintAny.asString model.subModel |> Element.text
            ]
        , Instructions.view instructions
            |> Element.el
                [ Element.width (Element.fillPortion 1)
                , Element.height Element.fill
                ]
        ]
        |> Element.layout [ Element.height Element.fill ]


queryValue : String -> Bool -> String
queryValue rawQuery hideAliases =
    if hideAliases then
        rawQuery
            |> stripAliases

    else
        rawQuery


toggleAliasesCheckbox : Element (Msg subMsg)
toggleAliasesCheckbox =
    label []
        [ input [ type_ "checkbox", onClick ToggleAliases ] []
        , text " Show Aliases "
        , a [ href "https://github.com/dillonkearns/elm-graphql/blob/master/FAQ.md#how-do-field-aliases-work-in-dillonkearnselm-graphql" ]
            [ text "(?)"
            ]
        ]
        |> Element.html


stripAliases : String -> String
stripAliases query =
    query
        |> Regex.replace
            (Regex.fromStringWith { multiline = True, caseInsensitive = True } "^(\\s*)\\w+: "
                |> Maybe.withDefault Regex.never
            )
            (\match -> match.submatches |> List.head |> Maybe.withDefault Nothing |> Maybe.withDefault "")
