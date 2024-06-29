local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local FluidTankInputAdapter = base.mintAdapter('FluidTankInputAdapter')

function FluidTankInputAdapter:beforeRegister ()
    self.prefix = 'mekfluidtank:'

    self.queries = {
        basic = {
            filled_percentage   = fn():call('getFilledPercentage'),
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
    
    -- TODO does not support energy or redstone mode
    -- self:withGenericMachineQueries()
end

return FluidTankInputAdapter