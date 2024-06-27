local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local AntiprotonicNucleosynthesizerInputAdapter = base.mintAdapter('AntiprotonicNucleosynthesizerInputAdapter')

function AntiprotonicNucleosynthesizerInputAdapter:beforeRegister ()
    self.prefix = 'mekapns:'

    self.queries = {
        basic = {
            input_chemical_filled_percentage    = fn():call('getInputChemicalFilledPercentage'),
            energy_usage                        = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_chemical                      = fn():call('getInputChemical'):get('amount'):div(1000):fluid(),
            input_chemical_capacity             = fn():call('getInputChemicalCapacity'):div(1000):fluid(),
            input_chemical_needed               = fn():call('getInputChemicalNeeded'):div(1000):fluid(),
        },
        output = {
            output_count                        = fn():call('getOutput'):get('count'):with('unit', 'item'),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return AntiprotonicNucleosynthesizerInputAdapter