local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local PigmentExtractorInputAdapter = base.mintAdapter('PigmentExtractorInputAdapter')

function PigmentExtractorInputAdapter:beforeRegister ()
    self.prefix = 'mekpigmentextractor:'

    self.queries = {
        basic = {
            input_count                 = fn():call('getInput'):get('count'):with('unit', 'item'),
            output_item_count           = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        output = {
            output                      = fn():call('getOutput'):get('amount'):div(1000):fluid(),
            output_capacity             = fn():call('getOutputCapacity'):div(1000):fluid(),
            output_needed               = fn():call('getOutputNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return PigmentExtractorInputAdapter