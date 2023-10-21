local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local CustomOutputAdapter = o.class(OutputAdapter)
CustomOutputAdapter.type = 'CustomOutputAdapter'

function CustomOutputAdapter:constructor (func)
    self.writelambda = func

    self:super('constructor')
end

function CustomOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    self.writelambda(collection)
end

return CustomOutputAdapter