#!/bin/bash -x
npx concurrently "elm-live \"$1/Main.elm\" --proxyPrefix /api --proxyHost http://localhost:4000 -- --output elm.js" "nodemon -q server/elm-stuff.js"
