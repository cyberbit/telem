local _Telem = {
    _VERSION = '0.3.0',
    util = require 'telem.lib.util',
    input = require 'telem.lib.input',
    output = require 'telem.lib.output',
    
    -- API
    backplane = require 'telem.lib.Backplane',
    metric = require 'telem.lib.Metric',
    metricCollection = require 'telem.lib.MetricCollection'
}

-- _Telem.util.log('init')

return _Telem