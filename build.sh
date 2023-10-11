#!/bin/bash

mkdir -p dist
rm -rf dist/*
echo 'building...'
luacc telem.init -o dist/telem.lua -i src $(for i in src/telem/lib/**/*.lua; do echo $i; done | sed 'y/\//./;s/^src.//;s/\.lua$//')

echo 'squishing...'
luamin -f dist/telem.lua > dist/telem.min.lua