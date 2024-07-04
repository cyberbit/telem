local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local RotaryCondensentratorInputAdapter = base.mintAdapter('RotaryCondensentratorInputAdapter')

function RotaryCondensentratorInputAdapter:beforeRegister ()
    self.prefix = 'mekcondense:'

    self.queries = {
        basic = {
            condensentrating                = fn():call('isCondensentrating'):toFlag(),
            gas_input_item_count            = fn():call('getGasItemInput'):get('count'):with('unit', 'item'),
            gas_filled_percentage           = fn():call('getGasFilledPercentage'),
            gas_output_item_count           = fn():call('getGasItemOutput'):get('count'):with('unit', 'item'),
            fluid_input_item_count          = fn():call('getFluidItemInput'):get('count'):with('unit', 'item'),
            fluid_filled_percentage         = fn():call('getFluidFilledPercentage'),
            fluid_output_item_count         = fn():call('getFluidItemOutput'):get('count'):with('unit', 'item'),
            energy_usage                    = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        gas = {
            gas                             = fn():call('getGas'):get('amount'):div(1000):fluid(),
            gas_capacity                    = fn():call('getGasCapacity'):div(1000):fluid(),
            gas_needed                      = fn():call('getGasNeeded'):div(1000):fluid(),
        },
        fluid = {
            fluid                           = fn():call('getFluid'):get('amount'):div(1000):fluid(),
            fluid_capacity                  = fn():call('getFluidCapacity'):div(1000):fluid(),
            fluid_needed                    = fn():call('getFluidNeeded'):div(1000):fluid(),
        },
    }
    
    self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return RotaryCondensentratorInputAdapter