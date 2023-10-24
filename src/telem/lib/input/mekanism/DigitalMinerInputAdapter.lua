local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'

local InputAdapter      = require 'telem.lib.InputAdapter'
local Metric            = require 'telem.lib.Metric'
local MetricCollection  = require 'telem.lib.MetricCollection'

local DigitalMinerInputAdapter = o.class(InputAdapter)
DigitalMinerInputAdapter.type = 'DigitalMinerInputAdapter'

function DigitalMinerInputAdapter:constructor (peripheralName, categories)
    self:super('constructor')

    -- TODO this will be a configurable feature later
    self.prefix = 'mekdigitalminer:'

    -- TODO make these constants
    local allCategories = {
        'basic',
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

function DigitalMinerInputAdapter:read ()
    self:boot()

    local source, miner = next(self.components)

    local metrics = MetricCollection()

    local loaded = {}

    for _,v in ipairs(self.categories) do
        -- skip, already loaded
        if loaded[v] then
            -- do nothing

        -- TODO: Maybe add `formation`and `advanced` later?
        elseif v == 'basic' then
            metrics:insert(Metric{ name = self.prefix .. 'energy_filled_percentage', value = (miner.getEnergyFilledPercentage()), unit = nil, source = source })
            metrics:insert(Metric{ name = self.prefix .. 'energy_usage', value = mekanismEnergyHelper.joulesToFE(miner.getEnergyUsage()), unit = "FE/t", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'item', value = miner.getToMine(), unit = "items", source = source })
            metrics:insert(Metric{ name = self.prefix .. 'running', value = (miner.isRunning() and 1 or 0), unit = nil, source = source })
        elseif v == 'energy'
            metrics:insert(Metric{ name = self.prefix .. 'energy', value = mekanismEnergyHelper.joulesToFE(miner.getEnergy()), unit = "FE", source = source })
        end

        loaded[v] = true
    end

    return metrics
end

return DigitalMinerInputAdapter