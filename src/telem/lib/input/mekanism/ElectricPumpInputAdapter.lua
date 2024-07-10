local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ElectricPumpInputAdapter = base.mintAdapter('ElectricPumpInputAdapter')

function ElectricPumpInputAdapter:beforeRegister ()
    self.prefix = 'mekpump:'

    self.queries = {
        basic = {
            input_item_count        = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            output_item_count       = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            fluid_filled_percentage = fn():call('getFluidFilledPercentage'),

            -- TODO: does not support energy usage? need to verify
            -- energy_usage            = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        output = {
            fluid                   = fn():call('getFluid'):get('amount'):div(1000):fluid(),
            fluid_capacity          = fn():call('getFluidCapacity'):div(1000):fluid(),
            fluid_needed            = fn():call('getFluidNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return ElectricPumpInputAdapter