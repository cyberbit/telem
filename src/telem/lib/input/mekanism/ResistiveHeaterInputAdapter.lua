local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ResistiveHeaterInputAdapter = base.mintAdapter('ResistiveHeaterInputAdapter')

function ResistiveHeaterInputAdapter:beforeRegister ()
    self.prefix = 'mekresheater:'

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
            temperature                 = fn():call('getTemperature'):temp(),
        },
        advanced = {
            environmental_loss          = fn():call('getEnvironmentalLoss'),
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }

    -- TODO energy_usage reflects usage target, not actual usage

    -- TODO does not support comparator
    -- self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return ResistiveHeaterInputAdapter