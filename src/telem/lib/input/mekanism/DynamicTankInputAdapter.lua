local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local DynamicTankInputAdapter = base.mintAdapter('DynamicTankInputAdapter')

function DynamicTankInputAdapter:beforeRegister ()
    self.prefix = 'mekdyntank:'

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage'),
            input_item_count    = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_item_count   = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
        },
        storage = {
            stored              = fn():call('getStored'):get('amount'):div(1000):fluid(),
            fluid_capacity      = fn():call('getTankCapacity'):div(1000):fluid(),
            chemical_capacity   = fn():call('getChemicalTankCapacity'):div(1000):fluid(),
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