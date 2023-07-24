local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local OutputAdapter     = require 'telem.lib.OutputAdapter'
local MetricCollection  = require 'telem.lib.MetricCollection'

local HelloWorldOutputAdapter = o.class(OutputAdapter)
HelloWorldOutputAdapter.type = 'HelloWorldOutputAdapter'

function HelloWorldOutputAdapter:constructor ()
    self:super('constructor')
end

function HelloWorldOutputAdapter:write (collection)
    assert(o.instanceof(collection, MetricCollection), 'Collection must be a MetricCollection')

    for k,v in pairs(collection.metrics) do
        print('Hello, ' .. v.name .. ' = ' .. v.value .. '!')
    end
end

return HelloWorldOutputAdapter