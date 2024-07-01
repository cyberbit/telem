local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LaserTractorBeamInputAdapter = base.mintAdapter('LaserTractorBeamInputAdapter')

function LaserTractorBeamInputAdapter:beforeRegister ()
    self.prefix = 'mektractorbeam:'

    self.queries = {
        basic = {
            slot_usage  = base.mintSlotUsageQuery('getSlotCount', 'getItemInSlot'),
            slot_count  = fn():call('getSlotCount'),
        }
    }

    -- TODO not sure the energy metrics mean anything to this component

    self:withGenericMachineQueries()
end

return LaserTractorBeamInputAdapter