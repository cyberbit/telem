-- Telem Vendor Loader by cyberbit
-- MIT License
-- Version 0.10.0
-- Submodules are copyright of their respective authors. For licensing, see https://github.com/cyberbit/telem/blob/main/LICENSE

if package.path:find('telem/vendor') == nil then package.path = package.path .. ';telem/vendor/?;telem/vendor/?.lua;telem/vendor/?/init.lua' end

return {
    ccryptolib = {
        random = require 'ccryptolib.random'
    },
    ecnet2 = require 'ecnet2',
    lualzw = require 'lualzw',
    plotter = require 'plotter',
    fluent = require 'fluent-entrypoint',
    luz = {
        decompress = require 'luz.decompress'
    }
}