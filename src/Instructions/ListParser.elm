module Instructions.ListParser exposing (ListIcon(..), list)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import FontAwesome
import Html.Attributes
import Mark exposing (Document)
import Mark.Default exposing (defaultTextStyle)
import Parser.Advanced as Parser exposing ((|.), (|=), Parser)


type ListIcon
    = Experiment
    | Bullet
    | Question
    | Number
        { reset : List (Maybe Int)
        , decorations : List String
        }


list :
    { icon : List Int -> ListIcon -> Element msg
    , style : List Int -> List (Element.Attribute msg)
    }
    -> Mark.Block (model -> List (Element msg))
    -> Mark.Block (model -> Element msg)
list config textParser =
    Mark.block "List"
        (\items model ->
            Element.column
                (config.style [])
                (List.reverse (Tuple.second (List.foldl (renderListItem config model []) ( 0, [] ) items)))
        )
        (Mark.nested
            { item = textParser
            , start =
                Mark.oneOf
                    [ Mark.exactly "-> " Experiment
                    , Mark.exactly "--> " Experiment
                    , Mark.exactly "(?) " Question
                    , Mark.exactly "- " Bullet
                    , Mark.exactly "-- " Bullet
                    , Mark.advanced
                        (Parser.loop ( [], [] ) numberIconParser)
                    ]
            }
        )


numberIconParser :
    ( List (Maybe Int), List String )
    -> Parser Mark.Context Mark.Problem (Parser.Step ( List (Maybe Int), List String ) ListIcon)
numberIconParser ( cursorReset, decorations ) =
    Parser.oneOf
        [ Parser.succeed
            (\reset decoration ->
                Parser.Loop
                    ( reset :: cursorReset
                    , decoration :: decorations
                    )
            )
            |= Parser.oneOf
                [ Parser.succeed
                    (\lead remaining ->
                        case ( String.toInt lead, String.toInt remaining ) of
                            ( Just l, Just r ) ->
                                Just <| (l * 10 * String.length remaining) + r

                            ( Just l, Nothing ) ->
                                Just l

                            _ ->
                                Nothing
                    )
                    |= Parser.getChompedString (Parser.chompIf Char.isDigit Mark.Integer)
                    |= Parser.getChompedString (Parser.chompWhile Char.isDigit)
                , Parser.succeed Nothing
                    |. Parser.chompIf (\c -> c == '#') (Mark.Expecting "#")
                ]
            |= Parser.getChompedString
                (Parser.chompWhile
                    (\c ->
                        c
                            /= ' '
                            && (c /= '#')
                            && not (Char.isDigit c)
                    )
                )
        , Parser.succeed
            (Parser.Done
                (Number
                    { reset = List.reverse cursorReset
                    , decorations = List.reverse decorations
                    }
                )
            )
            |. Parser.chompIf (\c -> c == ' ') Mark.Space
        ]


renderListItem :
    { a
        | icon : List Int -> ListIcon -> Element msg
        , style : List Int -> List (Element.Attribute msg)
    }
    -> b
    -> List Int
    -> Mark.Nested ( ListIcon, List (b -> List (Element msg)) )
    -> ( Int, List (Element msg) )
    -> ( Int, List (Element msg) )
renderListItem config model stack (Mark.Nested item) ( index, accumulated ) =
    case item.content of
        ( icon, items ) ->
            let
                ( newIndex, newStack ) =
                    advanceIndex icon index stack
            in
            ( newIndex
            , Element.row []
                [ Element.el [ Element.alignTop ]
                    (config.icon (newIndex :: newStack) icon)
                , Element.textColumn
                    (config.style (index :: stack))
                    (List.map
                        (\view ->
                            Element.paragraph
                                []
                                (view model)
                        )
                        items
                        ++ List.reverse (Tuple.second (List.foldl (renderListItem config model (newIndex :: newStack)) ( 0, [] ) item.children))
                    )
                ]
                :: accumulated
            )


advanceIndex : ListIcon -> Int -> List Int -> ( Int, List Int )
advanceIndex icon index stack =
    case icon of
        Number { reset } ->
            resetIndex reset (index + 1) stack

        _ ->
            ( index + 1, stack )


resetIndex : List (Maybe a) -> a -> List a -> ( a, List a )
resetIndex reset cursor stack =
    case List.reverse reset of
        [] ->
            ( cursor, stack )

        top :: remaining ->
            ( Maybe.withDefault cursor top
            , stack
                |> List.foldr resetStack ( remaining, [] )
                |> Tuple.second
            )


resetStack : a -> ( List (Maybe a), List a ) -> ( List (Maybe a), List a )
resetStack index ( reset, found ) =
    case reset of
        [] ->
            ( reset, index :: found )

        Nothing :: remain ->
            ( remain, index :: found )

        (Just new) :: remain ->
            ( remain, new :: found )
