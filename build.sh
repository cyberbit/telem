#!/bin/bash

workdir=$PWD

# glob the star
shopt -s globstar

mkdir -p dist
rm -rf dist/*\

echo 'building sources...'
luacc telem.init -p 4 -o dist/telem.lua \
    -i src -i src/telem/vendor \
    $(for i in src/telem/lib/**/*.lua; do echo $i; done | sed 'y/\//./;s/^src.//;s/\.lua$//') \
    telem.vendor \
    $(for i in src/telem/vendor/**/*.lua; do echo $i; done | sed 'y/\//./;s|^src.telem.vendor.||;s/\.lua$//' | awk '{ if ($1 != "init") { print } }')

# echo 'building vendors...'

# cd $workdir/src/telem/vendor

# # build vendor package
# luacc init -p 5 -o $workdir/dist/vendor.lua -i . $(for i in **/*.lua; do echo $i; done | sed 'y/\//./;s/^src.vendor.//;s/\.lua$//' | awk '{ if ($1 != "init") { print } }')

# patch redrun function
sed -i 's|\["redrun"\] = function()|["redrun"] = function(...)|g' $workdir/dist/telem.lua

cd $workdir

echo 'squishing...'
# mkdir -p dist/release
luamin -f dist/telem.lua > dist/tail.telem.min.lua
# luamin -f dist/vendor.lua > dist/release/tail.vendor.min.lua

echo 'writing header...'
awk 'NR>=1 && NR<=4' dist/telem.lua > dist/telem.min.lua
cat dist/tail.telem.min.lua >> dist/telem.min.lua

# awk 'NR>=1 && NR<=5' dist/vendor.lua > dist/release/vendor.min.lua
# cat dist/release/tail.vendor.min.lua >> dist/release/vendor.min.lua

echo 'cleaning up...'
rm dist/tail.telem.min.lua