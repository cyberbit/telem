local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ChemicalWasherInputAdapter = base.mintAdapter('ChemicalWasherInputAdapter')

function ChemicalWasherInputAdapter:beforeRegister ()
    self.prefix = 'mekwasher:'

    self.queries = {
        basic = {
            fluid_filled_percentage         = fn():call('getFluidFilledPercentage'),
            input_slurry_filled_percentage  = fn():call('getSlurryInputFilledPercentage'),
            output_slurry_filled_percentage = fn():call('getSlurryOutputFilledPercentage'),
            input_fluid_item_count          = fn():call('getFluidItemInput'):get('count'):with('unit', 'item'),
            output_fluid_item_count         = fn():call('getFluidItemOutput'):get('count'):with('unit', 'item'),
            energy_usage                    = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            fluid                           = fn():call('getFluid'):get('amount'):div(1000):fluid(),
            fluid_capacity                  = fn():call('getFluidCapacity'):div(1000):fluid(),
            fluid_needed                    = fn():call('getFluidNeeded'):div(1000):fluid(),
            input_slurry                    = fn():call('getSlurryInput'):get('amount'):div(1000):fluid(),
            input_slurry_capacity           = fn():call('getSlurryInputCapacity'):div(1000):fluid(),
            input_slurry_needed             = fn():call('getSlurryInputNeeded'):div(1000):fluid(),
        },
        output = {
            output_slurry                   = fn():call('getSlurryOutput'):get('amount'):div(1000):fluid(),
            output_slurry_capacity          = fn():call('getSlurryOutputCapacity'):div(1000):fluid(),
            output_slurry_needed            = fn():call('getSlurryOutputNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return ChemicalWasherInputAdapter