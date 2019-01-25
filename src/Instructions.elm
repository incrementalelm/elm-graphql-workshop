module Instructions exposing (Instructions, view)

import Element exposing (Element)
import Instructions.Parser
import Mark
import Mark.Default


type alias Instructions =
    { body : String
    , title : String
    }


view : Instructions -> Element msg
view instructions =
    instructions.body
        |> Mark.parse Instructions.Parser.document
        |> (\parseResult ->
                case parseResult of
                    Ok instructionsView ->
                        instructionsView ()

                    Err error ->
                        Element.text <| Debug.toString error
           )
