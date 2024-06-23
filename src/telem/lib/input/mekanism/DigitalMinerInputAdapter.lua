local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter  = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local DigitalMinerInputAdapter = o.class(BaseMekanismInputAdapter)
DigitalMinerInputAdapter.type = 'DigitalMinerInputAdapter'

function DigitalMinerInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekminer:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    local slotUsageQuery = fn()
        :transform(function (v)
            local slots = {}
            
            local function getSlot(slot)
                return function ()
                    slots[slot] = v.getItemInSlot(slot) or false
                end
            end
            
            local queue = {}
            for i = 0, v.getSlotCount() - 1 do
                table.insert(queue, getSlot(i))
            end

            parallel.waitForAll(table.unpack(queue))

            return slots
        end)
        :reduce(function (initial, _, v)
            if v and v.count and tonumber(v.count) > 0 then
                return initial + 1
            else
                return initial
            end
        end, 0)

    self.queries = {
        basic = {
            running                             = fn():call('isRunning'):toFlag(),
            slot_count                          = fn():call('getSlotCount'),
            state                               = fn():call('getState'):toLookup({ FINISHED = 1, IDLE = 2, PAUSED = 3, SEARCHING = 4 }),
            to_mine                             = fn():call('getToMine'),
            energy_usage                        = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
            slot_usage                          = slotUsageQuery,
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