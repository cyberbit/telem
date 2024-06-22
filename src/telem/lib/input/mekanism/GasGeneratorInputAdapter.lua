local o = require 'telem.lib.ObjectModel'
local t = require 'telem.lib.util'
local fn = require 'telem.vendor'.fluent.fn

local BaseMekanismInputAdapter = require 'telem.lib.input.mekanism.BaseMekanismInputAdapter'

local GasGeneratorInputAdapter = o.class(BaseMekanismInputAdapter)
GasGeneratorInputAdapter.type = 'GasGeneratorInputAdapter'

function GasGeneratorInputAdapter:constructor (peripheralName, categories)
    self:super('constructor', peripheralName)

    -- TODO this will be a configurable feature later
    self.prefix = 'mekgasgen:'

    -- TODO make these constants
    local allCategories = {
        'basic',
        'advanced',
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

    self.queries = {
        basic = {
            fuel_filled_percentage  = fn():call('getFuelFilledPercentage'),
            burn_rate               = fn():call('getBurnRate'):div(1000):fluidRate(),
        },
        fuel = {
            fuel                    = fn():call('getFuel'):get('amount'):div(1000):fluid(),
            fuel_capacity           = fn():call('getFuelCapacity'):div(1000):fluid(),
            fuel_needed             = fn():call('getFuelNeeded'):div(1000):fluid(),
        }
    }
    
    self:withGenericMachineQueries()
    self:withGeneratorQueries()
end

return GasGeneratorInputAdapter