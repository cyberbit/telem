#!/bin/bash

mkdir -p dist
rm -rf dist/*\

echo 'building Luz...'
luacc luz -o dist/luzc.lua compress decompress lex LibDeflate lz77 maketree minify token_decode_tree token_encode_map

echo 'squishing...'
mkdir -p dist/release
luamin -f dist/luzc.lua > dist/release/luzc.min.lua