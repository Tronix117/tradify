#!/bin/sh

node_modules/.bin/brunch build . && tibuild.py -rnv -i dist,.DS_Store,node_modules -o osx -t bundle -d ./dist/osx/ ./ && rm -Rf Resources dist/osx/Storific\ Translator.app