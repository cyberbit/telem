local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter  = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'
local Metric                    = require 'telem.lib.Metric'

local IsotopicCentrifugeInputAdapter = o.class(BaseMekanismInputAdapter)
IsotopicCentrifugeInputAdapter.type = 'IsotopicCentrifugeInputAdapter'

function IsotopicCentrifugeInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekcentrifuge:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
        'energy',
        'input',
        'output',
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    self.queries = {
        basic = {
            input_filled_percentage     = fn():call('getInputFilledPercentage'),
            output_filled_percentage    = fn():call('getOutputFilledPercentage'),
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