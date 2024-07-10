local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local SawingFactoryInputAdapter = base.mintAdapter('SawingFactoryInputAdapter')

function SawingFactoryInputAdapter:beforeRegister ()
    self.prefix = 'meksaw:'

    local factorySize = self:getFactorySize()

    self.queries = {
        basic = {
            input_count_sum             = base.mintSlotCountQuery(factorySize, 'getInput'):with('unit', 'item'),
            output_count_sum            = base.mintSlotCountQuery(factorySize, 'getOutput'):with('unit', 'item'),
            output_secondary_count_sum  = base.mintSlotCountQuery(factorySize, 'getSecondaryOutput'):with('unit', 'item'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        advanced = {
            auto_sort                   = fn():call('isAutoSortEnabled'):toFlag(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries(factorySize)

    -- getDirection
    -- getRedstoneMode
end

return SawingFactoryInputAdapter