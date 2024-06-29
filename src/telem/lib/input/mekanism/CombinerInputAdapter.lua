local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local CombinerInputAdapter = base.mintAdapter('CombinerInputAdapter')

function CombinerInputAdapter:beforeRegister ()
    self.prefix = 'mekcombiner:'

    self.queries = {
        basic = {
            input_main_count        = fn():call('getMainInput'):get('count'):with('unit', 'item'),
            input_secondary_count   = fn():call('getSecondaryInput'):get('count'):with('unit', 'item'),
            output_count            = fn():call('getOutput'):get('count'):with('unit', 'item'),
            energy_usage            = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return CombinerInputAdapter