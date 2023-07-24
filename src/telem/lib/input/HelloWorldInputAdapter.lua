local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local HelloWorldInputAdapter = o.class(InputAdapter)
HelloWorldInputAdapter.type = 'HelloWorldInputAdapter'

function HelloWorldInputAdapter:constructor (checkval)
    self.checkval = checkval

    self:super('constructor')
end

function HelloWorldInputAdapter:read ()
    return MetricCollection{ hello_world = self.checkval }
end

return HelloWorldInputAdapter