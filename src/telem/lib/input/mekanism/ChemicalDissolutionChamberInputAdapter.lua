local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ChemicalDissolutionChamberInputAdapter = base.mintAdapter('ChemicalDissolutionChamberInputAdapter')

function ChemicalDissolutionChamberInputAdapter:beforeRegister ()
    self.prefix = 'mekdissolution:'

    self.queries = {
        basic = {
            input_gas_filled_percentage = fn():call('getGasInputFilledPercentage'),
            input_gas_item_count        = fn():call('getInputGasItem'):get('count'):with('unit', 'item'),
            input_item_count            = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            output_item_count           = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_gas                   = fn():call('getGasInput'):get('amount'):div(1000):fluid(),
            input_gas_capacity          = fn():call('getGasInputCapacity'):div(1000):fluid(),
            input_gas_needed            = fn():call('getGasInputNeeded'):div(1000):fluid(),
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

return ChemicalDissolutionChamberInputAdapter