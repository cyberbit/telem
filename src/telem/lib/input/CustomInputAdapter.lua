local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local CustomInputAdapter = o.class(InputAdapter)
CustomInputAdapter.type = 'CustomInputAdapter'

function CustomInputAdapter:constructor (func)
    self.readlambda = func

    self:super('constructor')
end

function CustomInputAdapter:read ()
    return MetricCollection(self.readlambda())
end

return CustomInputAdapter