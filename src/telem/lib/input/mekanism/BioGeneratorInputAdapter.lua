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
        'fuel',
        'energy'
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
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = (generator.getEnergyFilledPercentage()), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'bio_fuel_filled_percentage', value = generator.getBioFuelFilledPercentage(), unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'production_rate', value = mekanismEnergyHelper.joulesToFE(generator.getProductionRate()), unit = "FE/t", source = source })
        elseif v == 'energy' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(generator.getEnergy()), unit = "FE", source = source })
        elseif v == 'fuel' then
            metrics:insert(Metric{ name = self.prefix .. 'bio_fuel_capacity', value = (generator.getBioFuelCapacity() / 1000), unit = "B", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'bio_fuel', value = (generator.getBioFuel().amount / 1000), unit = "B", source = source }) -- might error might not, no clue!
            metrics:insert(Metric{ name = self.prefix .. 'bio_fuel_needed', value = (generator.getBioFuelNeeded() / 1000), unit = 'B/t', source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return BioGeneratorInputAdapter

