local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local BioGeneratorInputAdapter = o.class(InputAdapter)
BioGeneratorInputAdapter.type = 'BioGeneratorInputAdapter'

function BioGeneratorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekbiogen:'

    -- TODO make these constants
    local allCategories = {
        'basic',
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

function BioGeneratorInputAdapter:read ()
    self:boot()

    local source, generator = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(generator.getEnergy()), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = (generator.getEnergyFilledPercentage()), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_capacity', value = generator.getBioFuelCapacity(), unit = "mB", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_amount', value = generator.getBioFuel().amount, unit = "mB", source = source }) -- might error might not, no clue!
            metrics:insert(Metric{ name = self.prefix .. 'fuel_filled_percentage', value = generator.getBioFuelFilledPercentage(), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'fuel_needed', value = generator.getBioFuelNeeded(), unit = 'mB/t', source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return BioGeneratorInputAdapter

