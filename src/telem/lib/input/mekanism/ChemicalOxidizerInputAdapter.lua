local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ChemicalOxidizerInputAdapter = base.mintAdapter('ChemicalOxidizerInputAdapter')

function ChemicalOxidizerInputAdapter:beforeRegister ()
    self.prefix = 'mekoxidizer:'

    self.queries = {
        basic = {
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_count                 = fn():call('getInput'):get('count'):with('unit', 'item'),
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

return ChemicalOxidizerInputAdapter