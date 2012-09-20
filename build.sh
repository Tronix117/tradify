#!/bin/sh

node_modules/.bin/brunch build . && ~/Library/Application\ Support/Titanium/sdk/osx/1.2.0.RC6e/tibuild.py -rnv -i dist,.DS_Store,node_modules -o osx -t bundle -d ./dist/osx/ ./ && rm -Rf Resources dist/osx/Tradify.app