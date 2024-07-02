local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local PaintingMachineInputAdapter = base.mintAdapter('PaintingMachineInputAdapter')

function PaintingMachineInputAdapter:beforeRegister ()
    self.prefix = 'mekpainting:'

    self.queries = {
        basic = {
            input_pigment_item_count        = fn():call('getInputPigmentItem'):get('count'):with('unit', 'item'),
            input_pigment_filled_percentage = fn():call('getPigmentInputFilledPercentage'),
            input_item_count                = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_count                    = fn():call('getOutput'):get('count'):with('unit', 'item'),
            energy_usage                    = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_pigment                   = fn():call('getPigmentInput'):get('amount'):div(1000):fluid(),
            input_pigment_capacity          = fn():call('getPigmentInputCapacity'):div(1000):fluid(),
            input_pigment_needed            = fn():call('getPigmentInputNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return PaintingMachineInputAdapter