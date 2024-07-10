local fn = require 'telem.vendor'.fluent.fn

local base  = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local IsotopicCentrifugeInputAdapter = base.mintAdapter('IsotopicCentrifugeInputAdapter')

function IsotopicCentrifugeInputAdapter:beforeRegister ()
    self.prefix = 'mekcentrifuge:'

    self.queries = {
        basic = {
            input_item_count            = fn():call('getInputItem'):get('count'):with('unit', 'item'),
            input_filled_percentage     = fn():call('getInputFilledPercentage'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            output_item_count           = fn():call('getOutputItem'):get('count'):with('unit', 'item'),
            energy_usage                = fn():call('getEnergyUsage'):joulesToFE():energyRate(),
        },
        input = {
            input                       = fn():call('getInput'):get('amount'):div(1000):fluid(),
            input_capacity              = fn():call('getInputCapacity'):div(1000):fluid(),
            input_needed                = fn():call('getInputNeeded'):div(1000):fluid(),
        },
        output = {
            output                      = fn():call('getOutput'):get('amount'):div(1000):fluid(),
            output_capacity             = fn():call('getOutputCapacity'):div(1000):fluid(),
            output_needed               = fn():call('getOutputNeeded'):div(1000):fluid(),
        },
    }

    self:withGenericMachineQueries()
end

return IsotopicCentrifugeInputAdapter