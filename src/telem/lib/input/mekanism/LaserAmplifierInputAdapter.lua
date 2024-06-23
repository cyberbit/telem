local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local LaserAmplifierInputAdapter = o.class(BaseMekanismInputAdapter)
LaserAmplifierInputAdapter.type = 'LaserAmplifierInputAdapter'

function LaserAmplifierInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'meklaseramp:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
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
        advanced = {
            delay                   = fn():call('getDelay'):with('unit', 't'),
            min_threshold           = fn():call('getMinThreshold'):joulesToFE():energy(),
            max_threshold           = fn():call('getMaxThreshold'):joulesToFE():energy(),
            redstone_output_mode    = fn():call('getRedstoneOutputMode'):toLookup({ ENERGY_CONTENTS = 1, ENTITY_DETECTION = 2, OFF = 3 }),
        },
    }

    self:withGenericMachineQueries()
end

return LaserAmplifierInputAdapter