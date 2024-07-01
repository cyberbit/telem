local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local MetallurgicInfuserInputAdapter = base.mintAdapter('MetallurgicInfuserInputAdapter')

function MetallurgicInfuserInputAdapter:beforeRegister ()
    self.prefix = 'mekmetalinfuser:'

    self.queries = {
        basic = {
            infuse_filled_percentage    = fn():call('getInfuseTypeFilledPercentage'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input_item_count            = fn():call('getInput'):get('count'):with('unit', 'item'),
            infuse_item_count           = fn():call('getInfuseTypeItem'):get('count'):with('unit', 'item'),
            infuse                      = fn():call('getInfuseType'):get('amount'):div(1000):fluid(),
            infuse_capacity             = fn():call('getInfuseTypeCapacity'):div(1000):fluid(),
            infuse_needed               = fn():call('getInfuseTypeNeeded'):div(1000):fluid(),
        },
        output = {
            output_count                = fn():call('getOutput'):get('count'):with('unit', 'item'),
        }
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getDirection
    -- getRedstoneMode
end

return MetallurgicInfuserInputAdapter