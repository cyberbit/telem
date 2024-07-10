local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ChemicalCrystallizerInputAdapter = base.mintAdapter('ChemicalCrystallizerInputAdapter')

function ChemicalCrystallizerInputAdapter:beforeRegister ()
    self.prefix = 'mekcrystallizer:'

    self.queries = {
        basic = {
            input_filled_percentage = fn():call('getInputFilledPercentage'),
            input_item_count        = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            energy_usage            = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input                   = fn():call('getInput'):get('amount'):div(1000):fluid(),
            input_capacity          = fn():call('getInputCapacity'):div(1000):fluid(),
            input_needed            = fn():call('getInputNeeded'):div(1000):fluid(),
        },
        output = {
            output_count            = fn():call('getOutput'):get('count'):with('unit', 'item'),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return ChemicalCrystallizerInputAdapter