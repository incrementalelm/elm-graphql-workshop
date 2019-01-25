-- Credit goes to wintvelt.
-- Copy pasted from https://github.com/wintvelt/elm-print-any since it hasn't been updated for 0.18


module PrintAny exposing
    ( view
    , asString
    )

{-| A tiny library for debugging purposes.
It prints any record to the console or to the DOM.

You can simply call `PrintAny.view myRecord` inside your `view` function,
to print `myRecord` to the DOM.

Or use `PrintAny.log myRecord` anywhere, to get a (somewhat) prettified version of the record in the console.

_PS: You may not want to use this with large records.
Performance is not optimal. This module iterates over a
string version of the record, which may take long time._


# Basics

@docs view


# Advanced

@docs config, viewWithConfig

-}

-- import Html exposing (Html, p, pre, text)
-- import Html.Attributes exposing (class, style)

import Element exposing (Element)
import Element.Font
import Html.Attributes
import String



{- Library constants -}


type alias Constants =
    { quote : String
    , indentChars : String
    , outdentChars : String
    , newLineChars : String
    }


constants : Constants
constants =
    { quote = "\""
    , indentChars = "[{("
    , outdentChars = "}])"
    , newLineChars = ","
    }


type Config
    = Config
        { increment : Int
        , className : String
        }


{-| Custom configuration of output to DOM.

With the `viewWithConfig` function, you can configure

  - `Int` indentation in pixels of individual lines
  - `String` class name for rendering the `<pre>` wrapper

Usage:

`viewWithConfig (config 20 "debug-record") myRecord`

Prints `record` to the DOM with the wrapper provide with class "debug-record",
and each line indented with increments of 20px.

The classname allows you to style the wrapper as well as the children elements in css.

-}
config : Int -> String -> Config
config increment className =
    Config
        { increment = increment
        , className = className
        }


indentIncrementPixels =
    20


view : a -> Element msg
view record =
    let
        lines =
            record
                |> Debug.toString
                |> splitWithQuotes
                |> splitUnquotedWithChars
                |> List.concat
                |> mergeQuoted
                |> addIndents
    in
    Element.column
        [ Element.Font.family [ Element.Font.monospace ]
        , Element.Font.size 14
        , Element.scrollbars
        , Element.height Element.fill
        , Element.explain Debug.todo
        ]
    <|
        List.map viewLine lines


asString : a -> String
asString record =
    record
        |> Debug.toString
        |> splitWithQuotes
        |> splitUnquotedWithChars
        |> List.concat
        |> mergeQuoted
        |> addIndents
        |> List.map (\( indentBy, line ) -> indentation indentBy ++ line)
        |> String.join "\n"


indentation : Int -> String
indentation remaining =
    if remaining > 0 then
        " " ++ indentation (remaining - 1)

    else
        ""



{- render a single formatted line to DOM -}


viewLine : ( Int, String ) -> Element msg
viewLine ( indent, string ) =
    Element.el
        [ Element.paddingEach { top = 0, right = 0, bottom = 0, left = indent * indentIncrementPixels } ]
        (Element.text string)



-- helpers


type alias IndentedString =
    { indentBefore : Int
    , string : String
    , indentAfter : Int
    }



{- take list of strings and add indentation, based on the first character in each string -}


addIndents : List String -> List ( Int, String )
addIndents stringList =
    stringList
        |> List.foldl addIndent []
        |> List.map (\r -> ( r.indentBefore, r.string ))



{- add indent to a single Item in a list -}


addIndent : String -> List IndentedString -> List IndentedString
addIndent string startList =
    case List.reverse startList of
        { indentAfter } :: other ->
            let
                firstChar =
                    String.left 1 string

                ( newIndentBefore, newIndentAfter ) =
                    if String.contains firstChar constants.indentChars then
                        ( indentAfter + 1, indentAfter + 1 )

                    else if String.contains firstChar constants.outdentChars then
                        ( indentAfter, indentAfter - 1 )

                    else
                        ( indentAfter, indentAfter )
            in
            startList
                ++ [ { indentBefore = newIndentBefore
                     , string = string
                     , indentAfter = newIndentAfter
                     }
                   ]

        [] ->
            [ { indentBefore = 0
              , string = string
              , indentAfter = 0
              }
            ]



{- If string is not in quotes, split based on characters,
   otherwise return unsplit string in a list
-}


splitUnquotedWithChars : List String -> List (List String)
splitUnquotedWithChars stringList =
    let
        splitString string =
            if String.left 1 string == constants.quote then
                [ string ]

            else
                splitWithChars
                    (constants.indentChars ++ constants.newLineChars ++ constants.outdentChars)
                    string
    in
    List.map splitString stringList



{- split a string with each of a set of characters, keeping the characters used to split -}


splitWithChars : String -> String -> List String
splitWithChars splitters string =
    case String.left 1 splitters of
        "" ->
            [ string ]

        char ->
            string
                |> splitWithChar char
                |> List.map (splitWithChars <| String.dropLeft 1 splitters)
                |> List.concat
                |> List.filter (\s -> s /= "")



{- split a string with a character, but keep the string or character used in splitting
   So:
   `splitWithChar "," "Apples, Bananas, Coconuts" == ["Apples", ", Bananas", ", Coconuts"]`
-}


splitWithChar : String -> String -> List String
splitWithChar splitter string =
    String.split splitter string
        |> List.indexedMap
            (\ind str ->
                if ind > 0 then
                    splitter ++ str

                else
                    str
            )



{- split a string with quoted parts, but keep quotes -}


splitWithQuotes : String -> List String
splitWithQuotes string =
    String.split "\"" string
        |> List.indexedMap
            (\i str ->
                if remainderBy 2 i == 1 then
                    "\"" ++ str ++ "\""

                else
                    str
            )



{- in a list of strings, add all quoted list items to the previous item in the list -}


mergeQuoted : List String -> List String
mergeQuoted =
    List.foldl mergeOneQuote []


mergeOneQuote : String -> List String -> List String
mergeOneQuote string startList =
    if String.left 1 string == constants.quote then
        -- append the string to the last line in the list
        case List.reverse startList of
            x :: xs ->
                ((x ++ string) :: xs)
                    |> List.reverse

            [] ->
                [ string ]

    else
        -- simply add string as line to the list
        startList ++ [ string ]



-- helpers


pad : Int -> String
pad indent =
    String.padLeft 5 '0' <| String.fromInt indent


splitLine : String -> ( Int, String )
splitLine line =
    let
        indent =
            String.left 5 line
                |> String.toInt
                |> Maybe.withDefault 0

        newLine =
            String.dropLeft 5 line
    in
    ( indent, newLine )
