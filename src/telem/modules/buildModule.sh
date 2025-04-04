#!/bin/bash

workdir=$PWD
modname=$1
outpath=${2:-dist/$modname.lua}

if [ -z "$modname" ]; then
  echo "Usage: $0 <modname> <outpath>"
  exit 1
fi

echo $workdir

# glob the star
shopt -s globstar

# rm $outpath

echo "building $modname..."
luacc $modname.init -o $outpath $(for i in $modname/**/*.lua; do [[ $i != "$modname/init.lua" ]] && echo $i; done | sed "y/\//./;s/\.lua$//")

# cd $workdir

echo 'packing...'

curl -so- https://raw.githubusercontent.com/cyberbit/telem/refs/heads/release/v0.10.0/src/telem/bin/luzc.lua | lua - $outpath ${outpath%.lua}.luz

# mkdir -p dist/release
# luamin -f dist/telem.lua > dist/release/tail.telem.min.lua
# luamin -f dist/vendor.lua > dist/release/tail.vendor.min.lua

# echo 'writing header...'
# awk 'NR>=1 && NR<=4' dist/telem.lua > dist/release/telem.min.lua
# cat dist/release/tail.telem.min.lua >> dist/release/telem.min.lua

# awk 'NR>=1 && NR<=5' dist/vendor.lua > dist/release/vendor.min.lua
# cat dist/release/tail.vendor.min.lua >> dist/release/vendor.min.lua

# echo 'cleaning up...'
# rm dist/release/tail.telem.min.lua dist/release/tail.vendor.min.lua

# echo 'publishing to computer #0...'
# cp dist/telem.lua /home/codespace/.local/share/craftos-pc/computer/0/telem/init.lua
# cp dist/vendor.lua /home/codespace/.local/share/craftos-pc/computer/0/telem/vendor.lua

# echo 'tarring...'
# tar -cf src.tar src