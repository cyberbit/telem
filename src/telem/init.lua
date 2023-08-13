local _Telem = {
    _VERSION = '0.0.3',
    util = require 'telem.lib.util',
    input = require 'telem.lib.input',
    output = require 'telem.lib.output',
    backplane = require 'telem.lib.Backplane'
}

-- _Telem.util.log('init')

return _Telem