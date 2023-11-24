if package.path:find('telem/vendor') == nil then package.path = package.path .. ';telem/vendor/?;telem/vendor/?.lua;telem/vendor/?/init.lua' end

local ecnet2 = require 'ecnet2'
local random = require 'ccryptolib.random'

return {
    ecnet2 = ecnet2,
    ccryptolib = {
        random = random
    }
}