#!/bin/bash -x
npx elm-live "$1/Main.elm" --proxyPrefix /api --proxyHost http://localhost:4000 --open -- --output elm.js
