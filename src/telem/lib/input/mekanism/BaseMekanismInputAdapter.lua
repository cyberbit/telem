local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local BaseMekanismInputAdapter = o.class(InputAdapter)
BaseMekanismInputAdapter.type = 'BaseMekanismInputAdapter'

function BaseMekanismInputAdapter:constructor (peripheralName)
    self:super('constructor')

    self.prefix = 'mek:'

    self.queries = {}

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
    self.queries.formation.isFormed = fn():call('isFormed'):toFlag()
    
    -- multiblock (formed)
    self.queries.formation.height   = fn():callElse('getHeight', 0):with('unit', 'm')
    self.queries.formation.length   = fn():callElse('getLength', 0):with('unit', 'm')
    self.queries.formation.width    = fn():callElse('getWidth', 0):with('unit', 'm')

    return self
end

function BaseMekanismInputAdapter:withGenericMachineQueries ()
    self.queries.basic = self.queries.basic or {}
    self.queries.advanced = self.queries.advanced or {}
    self.queries.energy = self.queries.energy or {}

    self.queries.basic.getEnergyFilledPercentage = fn():callElse('getEnergyFilledPercentage', 0)

    self.queries.advanced.getComparatorLevel = fn():callElse('getComparatorLevel', 0)

    self.queries.energy.getEnergy = fn():callElse('getEnergy', 0):joulesToFE():energy()
    self.queries.energy.getMaxEnergy = fn():callElse('getMaxEnergy', 0):joulesToFE():energy()
    self.queries.energy.getEnergyNeeded = fn():callElse('getEnergyNeeded', 0):joulesToFE():energy()

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

    self.queries.basic.energy_filled_percentage = fn():callElse('getEnergyFilledPercentage', 0)
    self.queries.basic.production_rate          = fn():callElse('getProductionRate', 0):joulesToFE():energyRate()

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

return BaseMekanismInputAdapter