local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter  = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric                    = require 'telem.lib.Metric'

local ChemicalTankInputAdapter = o.class(BaseMekanismInputAdapter)
ChemicalTankInputAdapter.type = 'ChemicalTankInputAdapter'

function ChemicalTankInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekchemtank:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'storage'
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
        advanced = {
            dumping_mode = fn():call('getDumpingMode'):toLookup({ IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }),
        },
        storage = {
            stored = fn():call('getStored'):get('amount'):div(1000):fluid(),
            capacity = fn():call('getCapacity'):div(1000):fluid(),
        },
    }

    self.storageQueries = {
        fn():call('getStored'):transform(function (v)
            return { Metric{ name = v.name, value = v.amount / 1000, unit = 'B' } }
        end)
    }

    -- getComparatorLevel
    -- getRedstoneMode
    
    -- TODO does not support energy
    -- self:withGenericMachineQueries()
end

return ChemicalTankInputAdapter