local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local InfusingFactoryInputAdapter = base.mintAdapter('InfusingFactoryInputAdapter')

function InfusingFactoryInputAdapter:beforeRegister ()
    self.prefix = 'mekmetalinfuse:'

    local factorySize = self:getFactorySize()

    self.queries = {
        basic = {
            input_count_sum             = base.mintSlotCountQuery(factorySize, 'getInput'):with('unit', 'item'),
            infuse_item_count           = fn():call('getInfuseTypeItem'):get('count'):with('unit', 'item'),
            infuse_filled_percentage    = fn():call('getInfuseTypeFilledPercentage'),
            output_count_sum            = base.mintSlotCountQuery(factorySize, 'getOutput'):with('unit', 'item'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        advanced = {
            auto_sort                   = fn():call('isAutoSortEnabled'):toFlag(),
        },
        input = {
            infuse                      = fn():call('getInfuseType'):get('amount'):div(1000):fluid(),
            infuse_capacity             = fn():call('getInfuseTypeCapacity'):div(1000):fluid(),
            infuse_needed               = fn():call('getInfuseTypeNeeded'):div(1000):fluid(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries(factorySize)

    -- getDirection
    -- getRedstoneMode
end

return InfusingFactoryInputAdapter