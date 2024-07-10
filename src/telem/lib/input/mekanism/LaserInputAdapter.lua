local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LaserInputAdapter = base.mintAdapter('LaserInputAdapter')

function LaserInputAdapter:beforeRegister ()
    self.prefix = 'meklaser:'

    self.queries = {
        basic = {
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage')
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }

    -- TODO only supports energy and direction
    -- self:withGenericMachineQueries()
end

return LaserInputAdapter