-- Telem Vendor Loader by cyberbit
-- MIT License
-- Version 0.5.0
-- Submodules are copyright of their respective authors. For licensing, see https://github.com/cyberbit/telem/blob/main/LICENSE

if package.path:find('telem/vendor') == nil then package.path = package.path .. ';telem/vendor/?;telem/vendor/?.lua;telem/vendor/?/init.lua' end

local ecnet2 = require 'ecnet2'
local random = require 'ccryptolib.random'
local plotter = require 'plotter'
local lualzw = require 'lualzw'

return {
    ccryptolib = {
        random = random
    },
    ecnet2 = ecnet2,
    lualzw = lualzw,
    plotter = plotter
}