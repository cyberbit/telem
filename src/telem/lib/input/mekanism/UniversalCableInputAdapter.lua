local o = require 'telem.lib.ObjectModel'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local UniversalCableInputAdapter = o.class(BaseMekanismInputAdapter)
UniversalCableInputAdapter.type = 'UniversalCableInputAdapter'

function UniversalCableInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekcable:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'transfer',
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
            filled_percentage   = fn():call('getFilledPercentage')
        },
        transfer = {
            buffer              = fn():call('getBuffer'):joulesToFE():energy(),
            capacity            = fn():call('getCapacity'):joulesToFE():energy(),
            needed              = fn():call('getNeeded'):joulesToFE():energy(),
        }
    }
end

return UniversalCableInputAdapter