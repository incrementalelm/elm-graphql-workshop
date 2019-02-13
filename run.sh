#!/bin/bash -x
SERVER_FILE="$(cat $1/server)"
# echo server file is "$SERVER_FILE"
npx concurrently "elm-live \"$1/Main.elm\" --proxyPrefix /api --proxyHost http://localhost:4000 -- --output elm.js" "nodemon -q server/$SERVER_FILE"
