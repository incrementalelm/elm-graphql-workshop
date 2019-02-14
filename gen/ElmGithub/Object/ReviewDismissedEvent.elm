-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module ElmGithub.Object.ReviewDismissedEvent exposing (actor, createdAt, databaseId, dismissalMessage, dismissalMessageHTML, id, message, messageHtml, previousReviewState, pullRequest, pullRequestCommit, resourcePath, review, url)

import ElmGithub.Enum.PullRequestReviewState
import ElmGithub.InputObject
import ElmGithub.Interface
import ElmGithub.Object
import ElmGithub.Scalar
import ElmGithub.ScalarCodecs
import ElmGithub.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Identifies the actor who performed the event.
-}
actor : SelectionSet decodesTo ElmGithub.Interface.Actor -> SelectionSet (Maybe decodesTo) ElmGithub.Object.ReviewDismissedEvent
actor object_ =
    Object.selectionForCompositeField "actor" [] object_ (identity >> Decode.nullable)


{-| Identifies the date and time when the object was created.
-}
createdAt : SelectionSet ElmGithub.ScalarCodecs.DateTime ElmGithub.Object.ReviewDismissedEvent
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (ElmGithub.ScalarCodecs.codecs |> ElmGithub.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| Identifies the primary key from the database.
-}
databaseId : SelectionSet (Maybe Int) ElmGithub.Object.ReviewDismissedEvent
databaseId =
    Object.selectionForField "(Maybe Int)" "databaseId" [] (Decode.int |> Decode.nullable)


{-| Identifies the optional message associated with the 'review\_dismissed' event.
-}
dismissalMessage : SelectionSet (Maybe String) ElmGithub.Object.ReviewDismissedEvent
dismissalMessage =
    Object.selectionForField "(Maybe String)" "dismissalMessage" [] (Decode.string |> Decode.nullable)


{-| Identifies the optional message associated with the event, rendered to HTML.
-}
dismissalMessageHTML : SelectionSet (Maybe String) ElmGithub.Object.ReviewDismissedEvent
dismissalMessageHTML =
    Object.selectionForField "(Maybe String)" "dismissalMessageHTML" [] (Decode.string |> Decode.nullable)


{-| -}
id : SelectionSet ElmGithub.ScalarCodecs.Id ElmGithub.Object.ReviewDismissedEvent
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (ElmGithub.ScalarCodecs.codecs |> ElmGithub.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Identifies the message associated with the 'review\_dismissed' event.
-}
message : SelectionSet String ElmGithub.Object.ReviewDismissedEvent
message =
    Object.selectionForField "String" "message" [] Decode.string


{-| The message associated with the event, rendered to HTML.
-}
messageHtml : SelectionSet ElmGithub.ScalarCodecs.Html ElmGithub.Object.ReviewDismissedEvent
messageHtml =
    Object.selectionForField "ScalarCodecs.Html" "messageHtml" [] (ElmGithub.ScalarCodecs.codecs |> ElmGithub.Scalar.unwrapCodecs |> .codecHtml |> .decoder)


{-| Identifies the previous state of the review with the 'review\_dismissed' event.
-}
previousReviewState : SelectionSet ElmGithub.Enum.PullRequestReviewState.PullRequestReviewState ElmGithub.Object.ReviewDismissedEvent
previousReviewState =
    Object.selectionForField "Enum.PullRequestReviewState.PullRequestReviewState" "previousReviewState" [] ElmGithub.Enum.PullRequestReviewState.decoder


{-| PullRequest referenced by event.
-}
pullRequest : SelectionSet decodesTo ElmGithub.Object.PullRequest -> SelectionSet decodesTo ElmGithub.Object.ReviewDismissedEvent
pullRequest object_ =
    Object.selectionForCompositeField "pullRequest" [] object_ identity


{-| Identifies the commit which caused the review to become stale.
-}
pullRequestCommit : SelectionSet decodesTo ElmGithub.Object.PullRequestCommit -> SelectionSet (Maybe decodesTo) ElmGithub.Object.ReviewDismissedEvent
pullRequestCommit object_ =
    Object.selectionForCompositeField "pullRequestCommit" [] object_ (identity >> Decode.nullable)


{-| The HTTP path for this review dismissed event.
-}
resourcePath : SelectionSet ElmGithub.ScalarCodecs.Uri ElmGithub.Object.ReviewDismissedEvent
resourcePath =
    Object.selectionForField "ScalarCodecs.Uri" "resourcePath" [] (ElmGithub.ScalarCodecs.codecs |> ElmGithub.Scalar.unwrapCodecs |> .codecUri |> .decoder)


{-| Identifies the review associated with the 'review\_dismissed' event.
-}
review : SelectionSet decodesTo ElmGithub.Object.PullRequestReview -> SelectionSet (Maybe decodesTo) ElmGithub.Object.ReviewDismissedEvent
review object_ =
    Object.selectionForCompositeField "review" [] object_ (identity >> Decode.nullable)


{-| The HTTP URL for this review dismissed event.
-}
url : SelectionSet ElmGithub.ScalarCodecs.Uri ElmGithub.Object.ReviewDismissedEvent
url =
    Object.selectionForField "ScalarCodecs.Uri" "url" [] (ElmGithub.ScalarCodecs.codecs |> ElmGithub.Scalar.unwrapCodecs |> .codecUri |> .decoder)