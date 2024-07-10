local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ChemicalWasherInputAdapter = base.mintAdapter('ChemicalWasherInputAdapter')

function ChemicalWasherInputAdapter:beforeRegister ()
    self.prefix = 'mekactivator:'

    local _, component = next(self.components)
    local supportsCanSeeSun = type(component.canSeeSun) == 'function'

    self.queries = {
        basic = {
            input_item_count                = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            input_filled_percentage         = fn():call('getInputFilledPercentage'),
            output_filled_percentage        = fn():call('getOutputFilledPercentage'),
            output_item_count               = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            production_rate                 = fn():call('getProductionRate'):div(1000):fluidRate(),
            peak_production_rate            = fn():call('getPeakProductionRate'):div(1000):fluidRate(),
        },
        input = {
            input                           = fn():call('getInput'):get('amount'):div(1000):fluid(),
            input_capacity                  = fn():call('getInputCapacity'):div(1000):fluid(),
            input_needed                    = fn():call('getInputNeeded'):div(1000):fluid(),
        },
        output = {
            output                          = fn():call('getOutput'):get('amount'):div(1000):fluid(),
            output_capacity                 = fn():call('getOutputCapacity'):div(1000):fluid(),
            output_needed                   = fn():call('getOutputNeeded'):div(1000):fluid(),
        }
    }

    -- Mekanism 10.3+ only
    if supportsCanSeeSun then
        self.queries.basic.sees_sun = fn():call('canSeeSun'):toFlag()
    end
    
    -- TODO does not support energy
    -- self:withGenericMachineQueries()

    -- getComparatorLevel
    -- getDirection
    -- getRedstoneMode
end

return ChemicalWasherInputAdapter