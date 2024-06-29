local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local ChemicalTankInputAdapter = base.mintAdapter('ChemicalTankInputAdapter')

function ChemicalTankInputAdapter:beforeRegister ()
    self.prefix = 'mekchemtank:'

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage'),
        },
        advanced = {
            dumping_mode        = fn():call('getDumpingMode'):toLookup({ IDLE = 1, DUMPING_EXCESS = 2, DUMPING = 3 }),
        },
        storage = {
            stored              = fn():call('getStored'):get('amount'):div(1000):fluid(),
            capacity            = fn():call('getCapacity'):div(1000):fluid(),
            needed              = fn():call('getNeeded'):div(1000):fluid(),
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