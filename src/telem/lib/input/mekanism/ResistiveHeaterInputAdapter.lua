local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ResistiveHeaterInputAdapter = base.mintAdapter('ResistiveHeaterInputAdapter')

function ResistiveHeaterInputAdapter:beforeRegister ()
    self.prefix = 'mekresheater:'

    local _, component = next(self.components)
    local supportsEnergyUsed = type(component.getEnergyUsed) == 'function'

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage'),
            energy_usage_target         = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
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

    -- Mekanism 10.3+ only
    if supportsEnergyUsed then
        self.queries.basic.energy_usage = fn():call('getEnergyUsed'):joulesToFE():energyRate()
    end


    -- TODO does not support comparator
    -- self:withGenericMachineQueries()

    -- getDirection
    -- getRedstoneMode
end

return ResistiveHeaterInputAdapter