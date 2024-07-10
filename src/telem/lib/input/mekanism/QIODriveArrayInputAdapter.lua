local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local base      = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric    = require 'telem.lib.Metric'

local QIODriveArrayInputAdapter = base.mintAdapter('QIODriveArrayInputAdapter')

function QIODriveArrayInputAdapter:beforeRegister ()
    self.prefix = 'mekqioarray:'

    local _, component = next(self.components)
    local arraySlots = component.getSlotCount()

    -- TODO frequency queries seem to break when the drive array frequency is changed

    self.queries = {
        basic = {
            frequency_selected      = fn():callElse('hasFrequency', false):toFlag(),
            item_filled_percentage  = fn():callElse('getFrequencyItemPercentage', 0),
            type_filled_percentage  = fn():callElse('getFrequencyItemTypePercentage', 0),
        },
        advanced = {
            -- placeholder for drive status queries
        },
        storage = {
            item_count              = fn():callElse('getFrequencyItemCount', 0):with('unit', 'item'),
            item_capacity           = fn():callElse('getFrequencyItemCapacity', 0):with('unit', 'item'),
            type_count              = fn():callElse('getFrequencyItemTypeCount', 0),
            type_capacity           = fn():callElse('getFrequencyItemTypeCapacity', 0),
        },
    }
    
    for i = 0, arraySlots - 1 do
        -- NEAR_FULL seems to be about 75% capacity usage
        self.queries.advanced['drive_status_' .. i] = fn():call('getDriveStatus', i):toLookup({
            READY = 1, NONE = 2, OFFLINE = 3, NEAR_FULL = 4, FULL = 5,
        })
    end

    -- storage queries only indicate the contents of the directly attached array,
    -- not the contents of the selected frequency. this is a Mekanism limitation
    self.storageQueries = {
        fn()
            :transform(function (v)
                local slotDetails = {}

                local queue = {}
                for i = 0, arraySlots - 1 do
                    table.insert(queue, function ()
                        slotDetails[i] = v.getDrive(i) or false
                    end)
                end

                parallel.waitForAll(table.unpack(queue))

                return slotDetails
            end)
            :mapSub(fn():get('nbt.mekData.qioItemMap', {}))
            :flatten()
            :mapValues(function (v) return { name = v.Item.id, value = v.amount } end)
            :sum('value', 'name')
            :map(function (k, v) return Metric{ name = k, value = v, unit = 'item' } end)
            :values()
    }

    -- getDirection
    
    -- TODO only supports direction
    -- self:withGenericMachineQueries()
end

return QIODriveArrayInputAdapter