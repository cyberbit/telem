local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fl = require 'telem.vendor'.fluent
local fn = fl.fn

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

---@class telem.BaseMekanismInputAdapter : telem.InputAdapter
local BaseMekanismInputAdapter = o.class(InputAdapter)
BaseMekanismInputAdapter.type = 'BaseMekanismInputAdapter'

function BaseMekanismInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    self.prefix = 'mek:'

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

function BaseMekanismInputAdapter:beforeRegister ()
    -- nothing by default, should be overridden by subclasses
end

function BaseMekanismInputAdapter:register ()
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

-- function BaseMekanismInputAdapter:queries (queries)
--     self.queries = queries

--     return self
-- end

--- Adds queries for multiblock structures.
---
--- Categories: formation
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

--- Adds queries for generic machines.
---
--- Categories: basic, advanced, energy
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

--- NYI
function BaseMekanismInputAdapter:withElectricMachineQueries ()
    --

    return self
end

--- NYI
function BaseMekanismInputAdapter:withFactoryMachineQueries ()
    --

    return self
end

--- Adds queries for generators.
---
--- Categories: basic, energy
function BaseMekanismInputAdapter:withGeneratorQueries ()
    self.queries.basic = self.queries.basic or {}
    self.queries.energy = self.queries.energy or {}

    self.queries.basic.production_rate      = fn():call('getProductionRate'):joulesToFE():energyRate()

    self.queries.energy.max_energy_output   = fn():call('getMaxOutput'):joulesToFE():energyRate()

    return self
end

--- NYI
function BaseMekanismInputAdapter:withRecipeProgressQueries ()
    self.queries.recipe = self.queries.recipe or {}

    self.queries.recipe.recipe_progress = fn():call('getRecipeProgress')
    self.queries.recipe.ticks_required  = fn():call('getTicksRequired'):with('unit', 't')

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

function BaseMekanismInputAdapter.mintAdapter (type)
    local adapter = o.class(BaseMekanismInputAdapter)
    adapter.type = type

    function adapter:constructor (peripheralName, categories)
        self:super('constructor', peripheralName, categories)
    end

    return adapter
end

return BaseMekanismInputAdapter