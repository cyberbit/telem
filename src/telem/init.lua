-- Telem by cyberbit
-- MIT License
-- Version 0.4.1

local _Telem = {
    _VERSION = '0.4.1',
    util = require 'telem.lib.util',
    input = require 'telem.lib.input',
    output = require 'telem.lib.output',
    
    -- API
    backplane = require 'telem.lib.Backplane',
    metric = require 'telem.lib.Metric',
    metricCollection = require 'telem.lib.MetricCollection'
}

local args = {...}

if #args < 1 or type(package.loaded['telem']) ~= 'table' then
    print('Telem ' .. _Telem._VERSION)
    print(' * A command-line interface is not yet implemented, please use require()')
end

return _Telem