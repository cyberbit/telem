local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fl = require 'telem.vendor'.fluent
local fn = fl.fn

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local BasePowahInputAdapter = o.class(InputAdapter)
BasePowahInputAdapter.type = 'BasePowahInputAdapter'

function BasePowahInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    self.prefix = 'powah:'

    self.categories = categories or { 'basic' }

    ---@type table<string, table<string, cyberbit.Fluent>>
    self.queries = {}

    ---@type cyberbit.Fluent[]
    self.storageQueries = {}

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()

    self:beforeRegister()

    self:register()
end

function BasePowahInputAdapter:beforeRegister ()
    -- nothing by default, should be overridden by subclasses
end

function BasePowahInputAdapter:register ()
    local allCategories = fl(self.queries):keys():result()

    if self.categories == '*' then
        self.categories = allCategories
    elseif type(self.categories) == 'table' then
        self.categories = fl(self.categories):intersect(allCategories):result()
    else
        error('categories must be a list of categories or "*"')
    end

    return self
end

--- Adds queries for generic machines.
---
--- Categories: basic
function BasePowahInputAdapter:withEnergyQueries ()
    self.queries.basic = self.queries.basic or {}

    self.queries.basic.energy       = fn():call('getEnergy'):energy()
    self.queries.basic.max_energy   = fn():call('getMaxEnergy'):energy()

    return self
end

local function queueHelper (results, index, query)
    return function ()
        results[index] = Metric(query:metricable():result())
    end
end

function BasePowahInputAdapter:read ()
    self:boot()
    
    local source, component = next(self.components)

    local tempMetrics = {}
    local queue = {}

    -- execute single-metric queries from a queue
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

    -- execute storage queries, which may return multiple metrics
    -- these have no category and are always included
    for k, v in pairs(self.storageQueries) do
        local tempResult = v:from(component):result()

        for _, metric in ipairs(tempResult) do
            metric.name = 'storage:' .. metric.name
            metric.source = source

            table.insert(tempMetrics, metric)
        end
    end

    return MetricCollection(table.unpack(tempMetrics))
end

------ Static Methods ------

function BasePowahInputAdapter.mintAdapter (type)
    local adapter = o.class(BasePowahInputAdapter)
    adapter.type = type

    function adapter:constructor (peripheralName, categories)
        self:super('constructor', peripheralName, categories)
    end

    return adapter
end

return BasePowahInputAdapter