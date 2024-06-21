local o = require 'telem.lib.ObjectModel'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local BaseAdvancedPeripheralsAdapter = o.class(InputAdapter)
BaseAdvancedPeripheralsAdapter.type = 'BaseAdvancedPeripheralsAdapter'

function BaseAdvancedPeripheralsAdapter:constructor (peripheralName)
    self:super('constructor')

    self.prefix = 'ap:'

    self.queries = {}

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

local function queueHelper (results, index, query)
    return function ()
        results[index] = Metric(query:metricable():result())
    end
end

function BaseAdvancedPeripheralsAdapter:read ()
    self:boot()

    local source, component = next(self.components)

    local tempMetrics = {}
    local queue = {}

    for _, category in ipairs(self.categories) do
        for k, v in pairs(self.queries[category]) do
            table.insert(queue, queueHelper(
                tempMetrics,
                #queue + 1,
                v:from(component):with('name', self.prefix .. k):with('source', source)
            ))
        end
    end

    parallel.waitForAll(table.unpack(queue))

    return MetricCollection(table.unpack(tempMetrics))
end

return BaseAdvancedPeripheralsAdapter