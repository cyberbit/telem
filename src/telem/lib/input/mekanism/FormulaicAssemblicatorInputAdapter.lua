local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FormulaicAssemblicatorInputAdapter = base.mintAdapter('FormulaicAssemblicatorInputAdapter')

function FormulaicAssemblicatorInputAdapter:beforeRegister ()
    self.prefix = 'mekassemblicator:'
            
    local function processSlot(method, slots, component, slot)
        return function ()
            slots[slot] = component[method](slot) or false
        end
    end

    local function mintSlotUsageQuery(getSlotsMethodName, getSlotItemMethodName)
        return fn()
            :transform(function (v)
                local slots = {}
                
                local queue = {}
                for i = 0, v[getSlotsMethodName]() - 1 do
                    table.insert(queue, processSlot(getSlotItemMethodName, slots, v, i))
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
    end

    local slotUsageQuery        = mintSlotUsageQuery('getSlots', 'getItemInSlot')
    local outputSlotUsageQuery  = mintSlotUsageQuery('getCraftingOutputSlots', 'getCraftingOutputSlot')

    self.queries = {
        basic = {
            input_slot_usage    = slotUsageQuery,
            input_slot_count    = fn():call('getSlots'),
            output_slot_usage   = outputSlotUsageQuery,
            output_slot_count   = fn():call('getCraftingOutputSlots'),

            -- TODO: does not support energy usage? need to verify
            -- energy_usage            = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },

        advanced = {
            valid_formula       = fn():call('hasValidFormula'):toFlag(),

            -- these throw errors when a valid formula is not installed
            auto_mode           = fn():callElse('getAutoMode', false):toFlag(),
            stock_control       = fn():callElse('getStockControl', false):toFlag(),
        },
    }
    
    self:withGenericMachineQueries()
        :withRecipeProgressQueries()

    -- getExcessRemainingItems
    -- getDirection
    -- getRedstoneMode
end

return FormulaicAssemblicatorInputAdapter