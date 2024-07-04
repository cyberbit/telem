local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local SeismicVibratorInputAdapter = base.mintAdapter('SeismicVibratorInputAdapter')

function SeismicVibratorInputAdapter:beforeRegister ()
    self.prefix = 'mekseismic:'

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }

    -- TODO Mekanism 10.2.5 does not have proper support for seismic vibrators,
    -- so only energy is supported for now. This will be updated in the future.
    
    -- TODO does not support comparator
    -- self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return SeismicVibratorInputAdapter