local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local LaserAmplifierInputAdapter = o.class(InputAdapter)
LaserAmplifierInputAdapter.type = 'LaserAmplifierInputAdapter'

function LaserAmplifierInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'meklaseramp:'

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

function LaserAmplifierInputAdapter:read ()
    self:boot()

    local source, laser = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- Literally all we have lmao
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = laser.getEnergy(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_max', value = laser.getMaxEnergy(), unit = "FE", source = source }) -- might error might not, no clue!
            metrics:insert(Metric{ name = self.prefix .. 'energy_needed', value = laser.getEnergyNeeded(), unit = "FE", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = laser.getEnergyFilledPercentage(), unit = nil, source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return LaserAmplifierInputAdapter

