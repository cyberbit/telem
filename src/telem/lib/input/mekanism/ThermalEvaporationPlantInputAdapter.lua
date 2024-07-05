local fn = require 'telem.vendor'.fluent.fn

local base = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local ThermalEvaporationPlantInputAdapter = base.mintAdapter('ThermalEvaporationPlantInputAdapter')

function ThermalEvaporationPlantInputAdapter:beforeRegister ()
    self.prefix = 'mekevap:'

    self.queries = {
        basic = {
            input_filled_percentage     = fn():call('getInputFilledPercentage'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
            input_input_item_count      = fn():call('getInputItemInput'):get('count'):with('unit', 'item'),
            input_output_item_count     = fn():call('getInputItemOutput'):get('count'):with('unit', 'item'),
            output_input_item_count     = fn():call('getOutputItemInput'):get('count'):with('unit', 'item'),
            output_output_item_count    = fn():call('getOutputItemOutput'):get('count'):with('unit', 'item'),
            production_amount           = fn():call('getProductionAmount'):div(1000):fluidRate(),
            temperature                 = fn():call('getTemperature'):temp(),
        },
        advanced = {
            environmental_loss          = fn():call('getEnvironmentalLoss'),
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
        formation = {
            active_solars               = fn():call('getActiveSolars'),
        },
    }

    self:withMultiblockQueries()

    -- TODO only supports comparator
    -- self:withGenericMachineQueries()

    -- getMinPos
    -- getMaxPos
    -- getComparatorLevel
end

return ThermalEvaporationPlantInputAdapter