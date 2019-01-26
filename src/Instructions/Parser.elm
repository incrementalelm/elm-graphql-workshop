module Instructions.Parser exposing (document)

import Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
import Html.Attributes
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
            , Mark.Default.list
                { style = listStyles
                , icon = Mark.Default.listIcon
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
