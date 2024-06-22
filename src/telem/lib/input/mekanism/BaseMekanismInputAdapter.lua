local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

---@class telem.BaseMekanismInputAdapter : telem.InputAdapter
local BaseMekanismInputAdapter = o.class(InputAdapter)
BaseMekanismInputAdapter.type = 'BaseMekanismInputAdapter'

function BaseMekanismInputAdapter:constructor (peripheralName)
    self:super('constructor')

    self.prefix = 'mek:'

    ---@type table<string, table<string, cyberbit.Fluent>>
    self.queries = {}

    ---@type cyberbit.Fluent[]
    self.storageQueries = {}

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

-- function BaseMekanismInputAdapter:queries (queries)
--     self.queries = queries

--     return self
-- end

function BaseMekanismInputAdapter:withMultiblockQueries ()
    self.queries.formation = self.queries.formation or {}

    -- multiblock
    self.queries.formation.formed   = fn():call('isFormed'):toFlag()
    
    -- multiblock (formed)
    self.queries.formation.height   = fn():call('getHeight'):with('unit', 'm')
    self.queries.formation.length   = fn():call('getLength'):with('unit', 'm')
    self.queries.formation.width    = fn():call('getWidth'):with('unit', 'm')

    return self
end

function BaseMekanismInputAdapter:withGenericMachineQueries ()
    self.queries.basic = self.queries.basic or {}
    self.queries.advanced = self.queries.advanced or {}
    self.queries.energy = self.queries.energy or {}

    self.queries.basic.energy_filled_percentage = fn():call('getEnergyFilledPercentage')

    self.queries.advanced.comparator_level      = fn():call('getComparatorLevel')

    self.queries.energy.energy                  = fn():call('getEnergy'):joulesToFE():energy()
    self.queries.energy.max_energy              = fn():call('getMaxEnergy'):joulesToFE():energy()
    self.queries.energy.energy_needed           = fn():call('getEnergyNeeded'):joulesToFE():energy()

    -- getDirection
    -- getRedstoneMode

    return self
end

function BaseMekanismInputAdapter:withElectricMachineQueries ()
    --

    return self
end

function BaseMekanismInputAdapter:withFactoryMachineQueries ()
    --

    return self
end

function BaseMekanismInputAdapter:withGeneratorQueries ()
    self.queries.basic = self.queries.basic or {}
    self.queries.energy = self.queries.energy or {}

    self.queries.basic.production_rate      = fn():call('getProductionRate'):joulesToFE():energyRate()

    self.queries.energy.max_energy_output   = fn():call('getMaxOutput'):joulesToFE():energyRate()

    return self
end

function BaseMekanismInputAdapter:withRecipeProgressQueries ()
    --

    return self
end

local function queueHelper (results, index, query)
    return function ()
        results[index] = Metric(query:metricable():result())
    end
end

function BaseMekanismInputAdapter:read ()
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

    -- for _,v in ipairs(queue) do
    --     v()
    -- end

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

return BaseMekanismInputAdapter