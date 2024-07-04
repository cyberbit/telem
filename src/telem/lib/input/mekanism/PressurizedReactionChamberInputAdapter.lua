local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local PressurizedReactionChamberInputAdapter = base.mintAdapter('PressurizedReactionChamberInputAdapter')

function PressurizedReactionChamberInputAdapter:beforeRegister ()
    self.prefix = 'mekreaction:'

    self.queries = {
        basic = {
            input_fluid_filled_percentage   = fn():call('getInputFluidFilledPercentage'),
            input_gas_filled_percentage     = fn():call('getInputGasFilledPercentage'),
            input_item_count                = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_item_count               = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            output_gas_filled_percentage    = fn():call('getOutputGasFilledPercentage'),
        },
        input = {
            input_fluid                     = fn():call('getInputFluid'):get('amount'):div(1000):fluid(),
            input_fluid_capacity            = fn():call('getInputFluidCapacity'):div(1000):fluid(),
            input_fluid_needed              = fn():call('getInputFluidNeeded'):div(1000):fluid(),
            input_gas                       = fn():call('getInputGas'):get('amount'):div(1000):fluid(),
            input_gas_capacity              = fn():call('getInputGasCapacity'):div(1000):fluid(),
            input_gas_needed                = fn():call('getInputGasNeeded'):div(1000):fluid(),
        },
        output = {
            output_gas                      = fn():call('getOutputGas'):get('amount'):div(1000):fluid(),
            output_gas_capacity             = fn():call('getOutputGasCapacity'):div(1000):fluid(),
            output_gas_needed               = fn():call('getOutputGasNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return PressurizedReactionChamberInputAdapter