#!/bin/bash

workdir=$PWD

# echo $workdir

# glob the star
shopt -s globstar

mkdir -p dist
rm -rf dist/*\

echo 'building sources...'
luacc telem.init -o dist/telem.lua -i src $(for i in src/telem/lib/**/*.lua; do echo $i; done | sed 'y/\//./;s/^src.//;s/\.lua$//')

echo 'building vendors...'

cd $workdir/src/telem/vendor

# build vendor package
luacc init -o $workdir/dist/vendor.lua -i . $(for i in **/*.lua; do echo $i; done | sed 'y/\//./;s/^src.vendor.//;s/\.lua$//' | awk '{ if ($1 != "init") { print } }')

# patch redrun function
sed -i 's|\["redrun"\] = function()|["redrun"] = function(...)|g' $workdir/dist/vendor.lua

cd $workdir

echo 'squishing...'
mkdir -p dist/release
luamin -f dist/telem.lua > dist/release/telem.min.lua
luamin -f dist/vendor.lua > dist/release/vendor.min.lua

# echo 'tarring...'
# tar -cf src.tar src