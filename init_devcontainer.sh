#!/bin/bash

# set up workspace
mkdir .luatmp
cd .luatmp

# install lua
sudo apt update
sudo apt install lua5.3 liblua5.3-dev

# install luarocks
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure && make && sudo make install

# install luacc
sudo luarocks install luacc

# remove workspace
cd ../..
rm -rf .luatmp

# install luamin
sudo yarn global add https://github.com/cyberbit/luamin