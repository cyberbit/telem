local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local DigitalMinerInputAdapter = base.mintAdapter('DigitalMinerInputAdapter')

function DigitalMinerInputAdapter:beforeRegister ()
    self.prefix = 'mekminer:'

    self.queries = {
        basic = {
            running                             = fn():call('isRunning'):toFlag(),
            slot_count                          = fn():call('getSlotCount'),
            state                               = fn():call('getState'):toLookup({ FINISHED = 1, IDLE = 2, PAUSED = 3, SEARCHING = 4 }),
            to_mine                             = fn():call('getToMine'),
            energy_usage                        = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
            slot_usage                          = base.mintSlotUsageQuery('getSlotCount', 'getItemInSlot'),
        },
        advanced = {
            auto_eject                          = fn():call('getAutoEject'):toFlag(),
            auto_pull                           = fn():call('getAutoPull'):toFlag(),
            inverse_mode                        = fn():call('getInverseMode'):toFlag(),
            inverse_mode_requires_replacement   = fn():call('getInverseModeRequiresReplacement'):toFlag(),
            max_radius                          = fn():call('getMaxRadius'):with('unit', 'm'),
            max_y                               = fn():call('getMaxY'),
            min_y                               = fn():call('getMinY'),
            radius                              = fn():call('getRadius'):with('unit', 'm'),
            silk_touch                          = fn():call('getSilkTouch'):toFlag(),
        },
    }

    self:withGenericMachineQueries()
end

return DigitalMinerInputAdapter