local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local AntiprotonicNucleosynthesizerInputAdapter = base.mintAdapter('AntiprotonicNucleosynthesizerInputAdapter')

function AntiprotonicNucleosynthesizerInputAdapter:beforeRegister ()
    self.prefix = 'mekapns:'

    self.queries = {
        basic = {
            input_chemical_filled_percentage    = fn():call('getInputChemicalFilledPercentage'),
            input_item_count                    = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_item_count                   = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            energy_usage                        = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_chemical                      = fn():call('getInputChemical'):get('amount'):div(1000):fluid(),
            input_chemical_capacity             = fn():call('getInputChemicalCapacity'):div(1000):fluid(),
            input_chemical_needed               = fn():call('getInputChemicalNeeded'):div(1000):fluid(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- TODO input_item_count?

    -- getDirection
    -- getRedstoneMode
end

return AntiprotonicNucleosynthesizerInputAdapter