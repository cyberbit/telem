local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local FormulaicAssemblicatorInputAdapter = base.mintAdapter('FormulaicAssemblicatorInputAdapter')

function FormulaicAssemblicatorInputAdapter:beforeRegister ()
    self.prefix = 'mekassemblicator:'

    self.queries = {
        basic = {
            input_slot_usage    = base.mintSlotUsageQuery('getSlots', 'getItemInSlot'),
            input_slot_count    = fn():call('getSlots'),
            output_slot_usage   = base.mintSlotUsageQuery('getCraftingOutputSlots', 'getCraftingOutputSlot'),
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