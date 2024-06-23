local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LaserInputAdapter = o.class(BaseMekanismInputAdapter)
LaserInputAdapter.type = 'LaserInputAdapter'

function LaserInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'meklaser:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'energy',
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
            energy_filled_percentage    = fn():call('getEnergyFilledPercentage')
        },
        energy = {
            energy                      = fn():call('getEnergy'):joulesToFE():energy(),
            max_energy                  = fn():call('getMaxEnergy'):joulesToFE():energy(),
            energy_needed               = fn():call('getEnergyNeeded'):joulesToFE():energy(),
        },
    }

    -- TODO only supports energy and direction
    -- self:withGenericMachineQueries()
end

return LaserInputAdapter