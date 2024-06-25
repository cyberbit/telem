local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LaserAmplifierInputAdapter = base.mintAdapter('LaserAmplifierInputAdapter')

function LaserAmplifierInputAdapter:beforeRegister ()
    self.prefix = 'meklaseramp:'

    self.queries = {
        advanced = {
            delay                   = fn():call('getDelay'):with('unit', 't'),
            min_threshold           = fn():call('getMinThreshold'):joulesToFE():energy(),
            max_threshold           = fn():call('getMaxThreshold'):joulesToFE():energy(),
            redstone_output_mode    = fn():call('getRedstoneOutputMode'):toLookup({ ENERGY_CONTENTS = 1, ENTITY_DETECTION = 2, OFF = 3 }),
        },
    }

    self:withGenericMachineQueries()
end

return LaserAmplifierInputAdapter