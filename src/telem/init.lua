-- Telem by cyberbit
-- MIT License
-- Version 0.10.0

local _Telem = {
    _VERSION = '0.10.0',
    util = require 'telem.lib.util',
    input = require 'telem.lib.input',
    output = require 'telem.lib.output',
    middleware = require 'telem.lib.middleware',
    
    -- API
    backplane = require 'telem.lib.Backplane',
    metric = require 'telem.lib.Metric',
    metricCollection = require 'telem.lib.MetricCollection',

    -- Vendor
    -- vendor = require 'telem.vendor',

    -- Modules
    module = require 'telem.lib.module'
}

-- bootstrap custom autoload
_Telem.module.autoload = function (path)
    assert(path and type(path) == 'string', 'path must be a string')
    
    return _Telem.module.autoloadModules(_Telem, path)
end

-- default autoload
_Telem.module.autoload('.telem/modules')

local args = {...}

if #args < 1 then
    print('Telem ' .. _Telem._VERSION)
    print(' * A command-line interface is not yet implemented, please use require()')
end

return _Telem
