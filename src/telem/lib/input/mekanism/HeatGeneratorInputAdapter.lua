local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local HeatGeneratorInputAdapter = base.mintAdapter('HeatGeneratorInputAdapter')

function HeatGeneratorInputAdapter:beforeRegister ()
    self.prefix = 'mekheatgen:'

    self.queries = {
        basic = {
            fuel_item_count         = fn():call('getFuelItem'):get('count'):with('unit', 'item'),
            lava_filled_percentage  = fn():call('getLavaFilledPercentage'),
            temperature             = fn():call('getTemperature'):temp(),
        },
        advanced = {
            transfer_loss           = fn():call('getTransferLoss'),
            environmental_loss      = fn():call('getEnvironmentalLoss'),
        },
        fuel = {
            lava                    = fn():call('getLava'):get('amount'):div(1000):fluid(),
            lava_capacity           = fn():call('getLavaCapacity'):div(1000):fluid(),
            lava_needed             = fn():call('getLavaNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
        :withGeneratorQueries()
end

return HeatGeneratorInputAdapter