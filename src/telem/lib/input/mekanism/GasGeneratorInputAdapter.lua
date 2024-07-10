local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local GasGeneratorInputAdapter = base.mintAdapter('GasGeneratorInputAdapter')

function GasGeneratorInputAdapter:beforeRegister ()
    self.prefix = 'mekgasgen:'

    self.queries = {
        basic = {
            fuel_filled_percentage  = fn():call('getFuelFilledPercentage'),
            burn_rate               = fn():call('getBurnRate'):div(1000):fluidRate(),
            fuel_item_count         = fn():call('getFuelItem'):get('count'):with('unit', 'item'),
        },
        fuel = {
            fuel                    = fn():call('getFuel'):get('amount'):div(1000):fluid(),
            fuel_capacity           = fn():call('getFuelCapacity'):div(1000):fluid(),
            fuel_needed             = fn():call('getFuelNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
        :withGeneratorQueries()
end

return GasGeneratorInputAdapter