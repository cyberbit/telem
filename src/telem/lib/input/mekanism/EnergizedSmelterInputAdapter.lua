local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local EnergizedSmelterInputAdapter = base.mintAdapter('EnergizedSmelterInputAdapter')

function EnergizedSmelterInputAdapter:beforeRegister ()
    self.prefix = 'meksmelt:'

    self.queries = {
        basic = {
            input_count     = fn():call('getInput'):get('count'):with('unit', 'item'),
            output_count    = fn():call('getOutput'):get('count'):with('unit', 'item'),
            energy_usage    = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return EnergizedSmelterInputAdapter