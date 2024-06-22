local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter  = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric                    = require 'telem.lib.Metric'

---@class telem.DynamicTankInputAdapter : telem.BaseMekanismInputAdapter
local DynamicTankInputAdapter = o.class(BaseMekanismInputAdapter)
DynamicTankInputAdapter.type = 'DynamicTankInputAdapter'

function DynamicTankInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekdyntank:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'storage',
        'formation'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self.queries = {
        basic = {
            filled_percentage = fn():call('getFilledPercentage'),
        },
        storage = {
            stored = fn():call('getStored'):get('amount'):div(1000):fluid(),
            fluid_capacity = fn():call('getTankCapacity'):div(1000):fluid(),
            chemical_capacity = fn():call('getChemicalTankCapacity'):div(1000):fluid(),
        },
    }

    self.storageQueries = {
        fn():call('getStored'):transform(function (v)
            return { Metric{ name = v.name, value = v.amount / 1000, unit = 'B' } }
        end)
    }

    self:withMultiblockQueries()

    -- getComparatorLevel
    
    -- TODO only supports comparator
    -- self:withGenericMachineQueries()
end

return DynamicTankInputAdapter