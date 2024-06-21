local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseAdvancedPeripheralsInputAdapter = require 'telem.lib.input.advancedPeripherals.BaseAdvancedPeripheralsInputAdapter'

local EnergyDetectorInputAdapter = o.class(BaseAdvancedPeripheralsInputAdapter)
EnergyDetectorInputAdapter.type = 'EnergyDetectorInputAdapter'

function EnergyDetectorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'apenergy:'

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

    self.queries = {
        basic = {
            transfer_rate       = fn():call('getTransferRate'):energyRate(),
            transfer_rate_limit = fn():call('getTransferRateLimit'):energyRate(),
        }
    }
end

return EnergyDetectorInputAdapter