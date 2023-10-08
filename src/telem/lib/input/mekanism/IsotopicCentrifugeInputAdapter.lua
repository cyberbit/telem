local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local IsotopicCentrifugeInputAdapter = o.class(InputAdapter)
IsotopicCentrifugeInputAdapter.type = 'IsotopicCentrifugeInputAdapter'

function IsotopicCentrifugeInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekunicable:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'input',
        'output'
    }

    if not categories then
        self.categories = { 'basic' }
    elseif categories == '*' then
        self.categories = allCategories
    else
        self.categories = categories
    end

    -- boot components
    self:setBoot(function ()
        self.components = {}

        self:addComponentByPeripheralID(peripheralName)
    end)()
end

function IsotopicCentrifugeInputAdapter:read ()
    self:boot()

    local source, centrifuge = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = centrifuge.getEnergy(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = centrifuge.getEnergyNeeded(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_usage', value = centrifuge.getEnergyUsage(), unit = "FE/t", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = centrifuge.getEnergyFilledPercentage(), unit = nil, source = source })
        elseif v == 'input' then
            metrics:insert(Metric{ name = self.prefix .. 'input', value = centrifuge.getInput().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'input_capacity', value = centrifuge.getInputCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'input_filled_percentage', value = centrifuge.getInputFilledPercentage(), unit = nil, source = source })
        elseif v == 'output' then
            metrics:insert(Metric{ name = self.prefix .. 'output', value = centrifuge.getOutput().amount / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'output_capacity', value = centrifuge.getOutputCapacity() / 1000, unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'output_filled_percentage', value = centrifuge.getOutputFilledPercentage(), unit = nil, source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return IsotopicCentrifugeInputAdapter

