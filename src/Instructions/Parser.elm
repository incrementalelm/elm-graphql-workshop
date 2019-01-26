module Instructions.Parser exposing (document)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import FontAwesome
import Html.Attributes
import Instructions.ListParser
import Mark exposing (Document)
import Mark.Default exposing (defaultTextStyle)


document : Mark.Document (model -> Element msg)
document =
    let
        defaultText =
            Mark.Default.textWith
                { defaultTextStyle
                    | code =
                        [ Background.color
                            (Element.rgba 0 0 0 0.04)
                        , Font.family
                            [ Font.external
                                { name = "Roboto Mono"
                                , url = "https://fonts.googleapis.com/css?family=Roboto+Mono"
                                }
                            , Font.monospace
                            ]
                        , Font.color (Element.rgba255 210 40 130 1)
                        , Border.rounded 2
                        , Element.paddingXY 5 3
                        ]
                }
    in
    Mark.document
        (\children model ->
            Element.textColumn
                [ Element.width Element.fill
                , Element.centerX
                , Font.family [ Font.typeface "Roboto" ]
                , Font.color (Element.rgba255 23 42 58 0.7)
                , Font.size 16
                , Element.spacing 10
                ]
                (List.map (\view -> view model) children)
        )
        (Mark.manyOf
            [ Mark.Default.header
                [ Font.size 36
                , Font.color (Element.rgba255 20 40 59 1)
                ]
                defaultText
            , Instructions.ListParser.list
                { style = listStyles
                , icon = listIcon
                }
                defaultText
            , image
            , Mark.Default.monospace
                [ Element.spacing 5
                , Element.padding 24
                , Background.color
                    (Element.rgba 0 0 0 0.04)
                , Border.rounded 2
                , Font.size 16
                , Font.family
                    [ Font.external
                        { name = "Roboto Mono"
                        , url = "https://fonts.googleapis.com/css?family=Roboto+Mono"
                        }
                    , Font.monospace
                    ]
                ]

            -- Toplevel Text
            , Mark.map (\viewEls model -> Element.paragraph [] (viewEls model)) defaultText
            ]
        )


image : Mark.Block (model -> Element msg)
image =
    Mark.record2 "Image"
        (\src description model ->
            Element.image
                [ Element.width (Element.fill |> Element.maximum 600)
                , Element.centerX
                ]
                { src = src
                , description = description
                }
                |> Element.el [ Element.centerX ]
        )
        (Mark.field "src" Mark.string)
        (Mark.field "description" Mark.string)


edges : { bottom : Int, left : Int, right : Int, top : Int }
edges =
    { top = 0
    , left = 0
    , right = 0
    , bottom = 0
    }


listIcon : List Int -> Instructions.ListParser.ListIcon -> Element msg
listIcon index symbol =
    let
        pad =
            Element.paddingEach
                { edges
                    | left = 28
                    , right = 12
                }
    in
    case symbol of
        Instructions.ListParser.Experiment ->
            FontAwesome.styledIcon "fas fa-flask"
                [ Element.paddingEach { edges | right = 5 }
                , Font.color (Element.rgba255 88 161 247 1)
                ]

        Instructions.ListParser.Bullet ->
            let
                icon =
                    case List.length index of
                        1 ->
                            "•"

                        _ ->
                            "◦"
            in
            Element.el [ pad ] (Element.text icon)

        Instructions.ListParser.Number numberConfig ->
            Element.el [ pad ]
                (Element.text
                    (index
                        |> List.foldl applyDecoration ( List.reverse numberConfig.decorations, [] )
                        |> Tuple.second
                        |> List.foldl formatIndex ""
                    )
                )


formatIndex : { a | decoration : String, index : Int, show : Bool } -> String -> String
formatIndex index formatted =
    if index.show then
        formatted ++ String.fromInt index.index ++ index.decoration

    else
        formatted


applyDecoration :
    a
    -> ( List String, List { decoration : String, index : a, show : Bool } )
    -> ( List String, List { decoration : String, index : a, show : Bool } )
applyDecoration index ( decs, decorated ) =
    case decs of
        [] ->
            -- If there are no decorations, skip.
            ( decs
            , { index = index
              , decoration = ""
              , show = False
              }
                :: decorated
            )

        currentDec :: remaining ->
            ( remaining
            , { index = index
              , decoration = currentDec
              , show = True
              }
                :: decorated
            )


listStyles : List Int -> List (Element.Attribute msg)
listStyles cursor =
    case List.length cursor of
        0 ->
            -- top level element
            [ Element.spacing 16 ]

        1 ->
            [ Element.spacing 16 ]

        2 ->
            [ Element.spacing 16 ]

        _ ->
            [ Element.spacing 8 ]
