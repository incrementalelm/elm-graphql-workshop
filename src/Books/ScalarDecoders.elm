-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Books.ScalarDecoders exposing (Upload, decoders)

import Books.Scalar exposing (defaultDecoders)
import Json.Decode as Decode exposing (Decoder)


type alias Upload =
    Books.Scalar.Upload


decoders : Books.Scalar.Decoders Upload
decoders =
    Books.Scalar.defineDecoders
        { decoderUpload = defaultDecoders.decoderUpload
        }
